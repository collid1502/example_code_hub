# deploy cluster mode (driver on cluster)
# client mode will retain driver on current machine 
# --py-files lets your provide any zipped python modules you may have 
spark-submit \
    --master yarn \
    --deploy-mode cluster \
    --driver-memory 2g \
    --executor-memory 2g \
    --executor-cores 4 \
    -- jars s3://my_bucket_location/folder1/jars/dummy1.jar,s3://my_bucket_location/folder1/jars/dummy2.jar \
    --py-files s3://myBucketLocation/usefulCode/PySparkUtils.zip \
    test.py 

# job can then be monitored from spark UI via AWS console 

# can also check logs as follows 
yarn logs -applicationId <application_id>

# if needing to kill a stuck application 
yarn application -kill <application_id> 