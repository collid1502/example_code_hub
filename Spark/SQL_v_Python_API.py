# imports
import pandas as pd
from pyspark.sql import SparkSession
import pyspark.sql.functions as F

#--------------------------------------------------------------------------
# stage 1 - use Pandas to read in local data 
acctData = pd.read_excel(r"Spark/dummyData/fakeAccounts.xlsx",
                         sheet_name="accounts",
                         header=0)
# view data
acctData.head(5) 

#--------------------------------------------------------------------------
# stage 2 - launch local spark session 
try:
    spark = SparkSession.builder \
        .appName("LocalSparkSession") \
        .master("local") \
        .getOrCreate()
    print("*** SPARK SESSION AVAILABLE THROUGH `spark`")
except Exception as e:
    print(e)

# push data from pandas to pyspark df 
spark_acctData = spark.createDataFrame(acctData)
spark_acctData.show(5, truncate=False)

# create dataframe into SQL view - allows for Spark SQL API
spark_acctData.createOrReplaceTempView("acct_data")
testQuery = """
select * from acct_data limit 5
"""
spark.sql(testQuery).show()

#--------------------------------------------------------------------------
# stage 3 - creating a new column example 
spark_acctData_new = spark_acctData.selectExpr("*", "'abc' as dummyNewVar")
spark_acctData_new.show() 

#--------------------------------------------------------------------------
# stage 4 - SQL API v Python API for the same outcome 

# SQL API 
acctsAggQuery = """
select
    date as businessDate, 
    brand as productBrand, 
    product,
    count(acctNum) as vol_of_accts

from acct_data
where brand = 'STAR' and date = '2022-12-01' 
group by date, brand, product 
order by vol_of_accts desc 
"""
sql_summary_df = spark.sql(acctsAggQuery)
sql_summary_df.show() 

# now in the Python API
py_summary_df = spark_acctData.filter("brand = 'STAR' and date = '2022-12-01'")\
                        .select(F.col('date'), F.col('brand'), F.col('product'), F.col('acctNum'))\
                        .groupBy("date", "brand", "product")\
                        .agg(F.count(F.col("acctNum")).alias("vol_of_accts"))\
                        .select("date","brand","product","vol_of_accts")\
                        .withColumnRenamed("brand", "productBrand")\
                        .withColumnRenamed("date", "businessDate")\
                        .orderBy(F.col("vol_of_accts").desc()) 

py_summary_df.show() 

# end of example 
spark.stop() 

exit(0) 