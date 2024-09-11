# run the docker compose script to build the dev environment for local spark development to mimic prod setup
docker-compose --env-file .env up -d 

# The -d flag runs the containers in detached mode, meaning they will run in the background.
# passing the .env file means you can provide environment variables to docker compose, referenced by ${variable},
# and then simply not commit the `.env` file to git, and avoid passwords or other confidential info being shared

# Access the Edge Node (Custom Image): 
# Since docker-compose specified the tty: true option for the aws-linux service, 
# you can interactively access the shell of your custom AWS Linux container (edge node) by running the following command:
docker exec -it edge-node /bin/bash

# verify running containers with:
# docker ps 