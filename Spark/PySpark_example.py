# below covers some PySpark examples, when working with a cluster etc
# imports
from pyspark.sql import SparkSession

useJarFiles = [
    's3://my_bucket_location/folder1/jars/dummy1.jar',
    's3://my_bucket_location/folder1/jars/dummy2.jar'
]
jarList = ",".join(useJarFiles) 

#Python version settings, this allows us to target an executor environment to match our driver 
pyspark_deps = f"s3://user/spark/shared/lib/pyspark4.8-deps/environment.tar.gz#environment"

# build spark session 
def getSpark(
        appName: str,
        driverMemory: str = "2G",
        executorMemory: str = "4G",
        executorCores: str = "5",
        queue: str = 'default',
        addJarFiles: list = [r"s3://user/spark/jdbc/jarsFiles/postgresql-42.6.0.jar"]
) -> object:
    """
    Simple function to return a spark session through object `spark`
    """
    spark = SparkSession\
            .builder\
            .appName(appName)\
            .enableHiveSupport()\
            .master("yarn")\
            .config("spark.driver.memory", driverMemory)\
            .config("spark.executor.memory", executorMemory)\
            .config("spark.yarn.queue", queue)\
            .config("spark.dynamicAllocation.enabled", "true")\
            .config("spark.dynamicAllocation.initialExecutors", "0")\
            .config("spark.dynamicAllocation.maxExecutors", "16")\
            .config("spark.dynamicAllocation.minExecutors", "1")\
            .config("spark.executors.cores", executorCores)\
            .config("spark.sql.hive.caseSensitiveInferenceMode", "INFER_ONLY")\
            .config("spark.sql.caseSensitive", "false")\
            .config("spark.sql.parquet.writeLegacyFormat", "true")\
            .config("spark.sql.sources.partitionOverwriteMode", "dynamic")\
            .config("hive.exec.dynamic.partition.mode", "nonstrict")\
            .config("spark.shuffle.service.enabled", "true")\
            .config("spark.dynamicAllocation.InitialExecutors", "0")\
            .config("spark.yarn.dist.archives", pyspark_deps)\
            .config("spark.jars", addJarFiles)\
            .getOrCreate()
    return spark


try:
    spark = getSpark(appName='Pyspark_EMR_Test') 
    print("PySpark session available through `spark` object")
except Exception as e:
    print(e)

# show databases 
databases = spark.sql("SHOW DATABASES")
databases.toPandas() 

spark.stop()

exit(0)