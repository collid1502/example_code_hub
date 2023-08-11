# required imports 
import os 
from json import dumps 
from pyspark.sql.types import BooleanType, StructType, StructField


# you need to have ensured spark session provided as function input has the relevant Scala JAR files
# added in via --JARS 
def AnalyticalDQ(
        sparkSession: object, params: dict, env: dict = {}, inputData: object = None
) -> object:
    """
    Simple example of using the SCALA JAR file for analytical DQ via PySpark 
    returns either success message, or the Exception from try-except block
    """
    if sparkSession == None:
        raise Exception("No Spark Session Provided")
    try:
        spark = sparkSession 
        sc = spark.sparkContext 
        logManager = sc._jvm.org.apache.log4j.LogManager
        logger = logManager.getLogger(__name__) 
    except Exception as e:
        print(e)
        raise 
    if env == None or bool(env) == False:
        ana_env_dict = {
            "Pipeline user": "Dummy Holder",
            "Pipeline version": "1"
        }
    else:
        ana_env_dict = env 
    
    # now create pipeline object, using streamsets import from JAR file 
    try:
        pipeline = spark._jvm.dq.streamsets.Pipeline(params, ana_env_dict)
        if inputData != None:
            # call analytical engine 
            spark._jvm.dq.analytical.Analytical.run(pipeline, inputData._jdf) 
        else:
            useData = spark.createDataFrame(data=[[True]], schema=StructType([StructField("__no_input_data__", BooleanType(), True)])) 
            # call analytical engine and use dummy df above 
            spark._jvm.dq.analytical.Analytical.run(pipeline, useData._jdf)
        # if no errors - return status Success
        status = "SUCCESS"
    except Exception as e:
        status = e 
    return status


if __name__ == "__main__":
    AnalyticalDQ() 