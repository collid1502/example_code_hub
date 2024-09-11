Create a custom image, based on AWS Linux, to ensure we have an "edge node" style machine as part of the Docker network, which can communicate with the Mini Spark cluster we are creating and submit jobs / connect to it.

This image will download all the spark, iceberg & Python dependencies for the tasks we will be developing.

Use the `Dockerfile` in this directory, to build the custom image for use in the docker-compose one level up.

steps:

```
docker build -t custom_aws_instance:v1 -f .
``` 

once built, it can be ran in interactive mode with:

```
docker run -it custom_aws_instance:v1
```