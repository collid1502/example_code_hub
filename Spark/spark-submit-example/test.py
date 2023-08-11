# spark available through `spark` object by default with spark-submit 
# print will be written to stdout and can be viewed via YARN in command line on master node 
print("Running show databases test")
try:
    spark.sql("show databases").show(10, truncate=False)
    print("successful show databases test")
except Exception as e:
    print(e)

print("Ending spark session")
spark.stop()