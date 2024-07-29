# Imports 
from pyspark.sql import SparkSession 
from pyspark.sql import functions as F 


def getSpark():
    spark = (SparkSession.builder\
                .appName("simple_etl")\
                .master("local")\
                .getOrCreate()
    )
    return spark 


def read_data(filepath: str, spark: object):
    in_data = (
        spark.read
        .option("delimiter", ",")
        .option("header", True)
        .option("inferSchema", "true")
        .csv(filepath)
    )
    return in_data 


def assign_country_py(data: object):
    df_with_country = (
        data.withColumn(
            "Country",
            F.when(
                F.col("Company").isin(["Wernham Hogg"]),
                "UK"
            )
            .otherwise("USA")
        )
    )
    return df_with_country


def assign_country_sql(data: object, spark: object):
    df_with_country = (
        spark.sql("""
        SELECT
            *,
            CASE 
                WHEN COMPANY = 'Wernham Hogg' THEN 'UK'
                ELSE 'USA'
            END AS COUNTRY
        FROM {source_df}""", source_df=data)
        )
    return df_with_country


if __name__ == "__main__":
    spark = getSpark() # get spark session 
    office_data = read_data(filepath="./tests/resources/input_staff.csv", spark=spark)
    data_with_countries = assign_country_py(office_data)
    data_with_countries.show()
    spark.stop()
