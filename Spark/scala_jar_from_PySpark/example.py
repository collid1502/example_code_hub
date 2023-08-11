# assume spark session available through object `spark` and a dataFrame called dummyData
# imports 
from pyspark.sql import SparkSession, Row
from nwdeequ.spark import AnalyticalDQ

spark = SparkSession\
            .builder\
            .appName("PySpark_Scala_JAR_test")\
            .enableHiveSupport()\
            .master("yarn")\
            .config("spark.jars", "/path/to/scala/jar/file/analyticaldq.jar")\
            .getOrCreate()

dataSetup = {
    "name": ["Dan", "Jon"],
    "age": [30, 33]
}
# convert dict to RDD of rows
rows = [Row(**dataSetup) for data in zip(*dataSetup.values())] 
# now create df from rdd
dummyData = spark.createDataFrame(rows)
dummyData.toPandas() # show the data 

myParams = {"dq_ruleset_id": "1915"}
myEnv = {} # leave empty and use default from function 

testRun = AnalyticalDQ(sparkSession=spark, params=myParams, env=myEnv, inputData=dummyData)
print(testRun)

spark.stop()
exit(0) 