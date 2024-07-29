# imports
from math import e
import pytest
from pyspark.sql import functions as F 
from etl.simple_etl import assign_country_py

# can make use of the fixture(s) from `conftest.py` by calling the `spark` fixture to get a session 

def test_assign_country_py(spark):
    # read in source data 
    source_data = (spark
        .read
        .option("delimiter", ",")
        .option("header", True)
        .option("inferSchema", "true")
        .csv("./tests/resources/input_staff.csv")
    ) 
    result = assign_country_py(source_data) # essentially, testing this function works as expected 

    exepected_result = (spark
        .read
        .option("delimiter", ",")
        .option("header", True)
        .option("inferSchema", "true")
        .csv("./tests/resources/output_staff.csv")
    ) 
    assert sorted(result.collect()) == sorted(exepected_result.collect()) 
