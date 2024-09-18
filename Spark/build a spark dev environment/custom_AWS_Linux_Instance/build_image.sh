#!/bin/bash  

# specify the paths to the relevant dockerfiles
# we can now build some custom docker images to use 

# "-t" option tags the resulting image with a name
# "-f" option specifies the path to the relevant dockerfile
# --no-cache ensures a clean, new build at run time
# "." at the end represents the build context, which is the current directory

## format:  docker build -t >image_name>:<tag> -f <path/to/dockerfile> . 
docker build \
    --build-arg MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD \
    -t custom_aws_instance:v1 .
