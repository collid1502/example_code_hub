# imports 
from pprint import pformat
from snowflake.snowpark.types import IntegerType, StringType, StructType, \
    StructField, ArrayType, TimestampType, BooleanType, VariantType


# This metadata drives the API calls, by passing in all required information 
api_etl_metadata = {
    "STORES": {
        "api_target": "stores",
        "queryParams": {"per_page": "100", "sort": "created_at", "order": "desc"},
        "extract_columns": [
                'id', 'name', 'description', 'fields', 'created_at', 'updated_at'
            ],
        "snowflakeSchema": StructType(
                [
                    StructField("Store ID", IntegerType()), 
                    StructField("Name", StringType()), 
                    StructField("Description", StringType()),
                    StructField("Fields", ArrayType()),
                    StructField("Created At", TimestampType()), 
                    StructField("Updated At", TimestampType())
                ]
            )
        },

    "PRODUCTS": {
        "api_target": "products",
        "queryParams": {"per_page": "100", "sort": "created_at", "order": "desc"},
        "extract_columns": [
                'id', 'name', 'created_at', 'updated_at'
            ],
        "snowflakeSchema": StructType(
                [
                    StructField("Product ID", IntegerType()),
                    StructField("Name", StringType()),
                    StructField("Created At", TimestampType()),
                    StructField("Updated At", TimestampType())
                ]
            )
        }
}


if __name__ == "__main__":
    print(pformat(prevalent_etl_metadata))
