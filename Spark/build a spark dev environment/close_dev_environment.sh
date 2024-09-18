#!/bin/bash  

# stop containers without removing them
# docker-compose stop 

# sut down & remove containers
# This command stops the containers and removes the containers, networks, and optionally the volumes created by Docker Compose
docker-compose down -v 
# -v: Removes named volumes declared in the volumes section of the Compose file and anonymous volumes attached to containers

# clear any files persisted as part of the Docker Container(s) for MinIO
rm -rf /tmp/minio 

# end