# json_pipeline_demo.py

import json
import random
import yaml
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_json, explode
from pyspark.sql.types import *

# =========================================================
# 1. FAKE DATA GENERATOR
# =========================================================

def generate_fake_json(row_id: int):
    num_items = random.randint(1, 3)

    data = {
        "order_id": f"order_{row_id}",
        "items": []
    }

    for i in range(num_items):
        item = {
            "item_id": f"item_{row_id}_{i}",
            "attributes": []
        }

        num_attrs = random.randint(1, 3)

        for j in range(num_attrs):
            attr = {
                "key": random.choice(["color", "size", "weight"]),
                "value": random.choice(["red", "blue", "M", "L", "10kg"])
            }
            item["attributes"].append(attr)

        data["items"].append(item)

    return json.dumps(data)


def create_test_dataframe(spark, n_rows=5):
    data = [(i, generate_fake_json(i)) for i in range(n_rows)]
    return spark.createDataFrame(data, ["row_id", "json_col"])


# =========================================================
# 2. YAML CONFIG (INLINE FOR DEMO)
# =========================================================

yaml_config = """
dataset: item_attributes

fields:
  - name: order_id
    path: order_id
    type: string

  - name: item_id
    path: items[].item_id
    type: string

  - name: attr_key
    path: items[].attributes[].key
    type: string

  - name: attr_value
    path: items[].attributes[].value
    type: string
"""

config = yaml.safe_load(yaml_config)


# =========================================================
# 3. JSON FLATTENER CLASS
# =========================================================

class JsonFlattener:
    def __init__(self, config: dict):
        self.config = config
        self.fields = config["fields"]

        self.type_map = {
            "string": StringType(),
            "integer": IntegerType(),
            "double": DoubleType(),
            "boolean": BooleanType(),
        }

        self.tree = self._build_tree()
        self.schema = self._tree_to_schema(self.tree)
        self.array_paths = self._extract_array_paths()
        self._validate_hierarchy()

    def _build_tree(self):
        tree = {}

        for f in self.fields:
            parts = f["path"].split(".")
            current = tree

            for i, part in enumerate(parts):
                is_array = part.endswith("[]")
                key = part.replace("[]", "")

                if i == len(parts) - 1:
                    if is_array:
                        current[key] = {
                            "__is_array__": True,
                            "__leaf_type__": f["type"]
                        }
                    else:
                        current[key] = f["type"]
                else:
                    if key not in current:
                        current[key] = {}

                    if is_array:
                        current[key]["__is_array__"] = True

                    current = current[key]

        return tree

    def _tree_to_schema(self, tree):
        fields = []

        for key, value in tree.items():

            if isinstance(value, dict) and "__leaf_type__" in value:
                field_type = ArrayType(self.type_map[value["__leaf_type__"]])

            elif isinstance(value, dict):
                is_array = value.pop("__is_array__", False)
                nested_struct = self._tree_to_schema(value)

                field_type = ArrayType(nested_struct) if is_array else nested_struct

            else:
                field_type = self.type_map[value]

            fields.append(StructField(key, field_type))

        return StructType(fields)

    def _extract_array_paths(self):
        paths = set()

        for f in self.fields:
            parts = f["path"].split(".")
            current = []

            for p in parts:
                if p.endswith("[]"):
                    key = p.replace("[]", "")
                    current.append(key)
                    paths.add(tuple(current))
                else:
                    current.append(p)

        return sorted(paths, key=len)

    def _validate_hierarchy(self):
        for i, path in enumerate(self.array_paths):
            for other in self.array_paths[i + 1:]:

                if not (path == other[:len(path)] or other == path[:len(other)]):
                    raise ValueError(
                        f"Non-hierarchical arrays detected: {path} and {other}"
                    )

    def transform(self, df, json_col="json_col"):
        parsed_col = from_json(col(json_col), self.schema)
        df_work = df.withColumn("parsed", parsed_col)

        # Explode arrays
        for path in self.array_paths:
            col_expr = "parsed." + ".".join(path)
            alias = path[-1]

            df_work = df_work.withColumn(alias, explode(col(col_expr)))

        # Flatten
        return df_work.select([
            self._build_column(f["path"]).alias(f["name"])
            for f in self.fields
        ])

    def _build_column(self, path):
        parts = path.split(".")
        c = col("parsed")

        for p in parts:
            key = p.replace("[]", "")
            c = c[key]

        return c


# =========================================================
# 4. MAIN EXECUTION
# =========================================================

if __name__ == "__main__":
    spark = SparkSession.builder \
        .appName("JsonFlattenerDemo") \
        .getOrCreate()

    # Create fake data
    df = create_test_dataframe(spark, n_rows=5)

    print("\n=== RAW DATA ===")
    df.show(truncate=False)

    # Run pipeline
    flattener = JsonFlattener(config)

    df_flat = flattener.transform(df)

    print("\n=== FLATTENED DATA ===")
    df_flat.show(truncate=False)

    # Optional: write to Delta
    # df_flat.write.format("delta").mode("overwrite").saveAsTable(config["dataset"])

    spark.stop()
```
