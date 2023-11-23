# Docker in local development

The use of docker in local development should ease the transition of moving an application to cloud, by using images to run on cloud hosted services etc.

## Docker Installation (Locally)

For this guide, docker will be installed in Linux, using an Ubuntu distribution on WSL. <br>
Docker Enginge (CE) Community Edition which is the free, open-source version will be installed. Start by updating the APT package index and installing required dependencies:

    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl software-properties-common

Then, add the Docker GPG key to your system:

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

now, add the Docker APT repository. You'll need to know which architecture you are on and choose the appropriate repository. This can be checked via the command line:

    dpkg --print-architecture

Which returns `**ARM64**` for my setup. As such, this will be the repo to choose. Add this by:

    echo "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

Now, update APT package index again to include the new Docker repo:

    sudo apt update

At this point, I then refresh my terminal and begin the Docker installation:

    source ~/.bashrc
    sudo apt install docker-ce

Once this has indeed installed, we can enable Docker, start the service & run a quick version check:

    # enable 
    sudo systemctl enable docker

    # start Docker
    sudo service docker start 

    # this should return a message: `* Starting Docker: docker`
    # we can also check what version was installed:
    sudo docker --version

I have installed: `Docker version 24.0.7, build afdd53b` <br>

We can also check the status of Docker at any stage to see if it is already running, by:

    sudo service docker status 

    # and should we wish to stop it
    sudo service docker stop 

With Docker running, we can perform a quick smoke test of the "hello world" variety. By running:

    sudo docker run hello-world 

This command will download and run a test container to ensure Docker is functioning correctly after the installation steps above.

And assuming that returns a success message to the terminal, it's all set up to go!

You can also check that Docker has been correctly installed to your system PATH if `docker --version` works for you.

#### Enabling Docker CLI for the non-root user

So far, the above will all have been done requiring ROOT privs with SUDO. <br>
To avoid this, and allow a regular user Docker CLI access without SUDO, we can do the following:

Ensure the `docker` group exists, and if it doesn't, create it. Note, based on above install it should do, but you can run this anyway:

    sudo groupadd docker

Once it's confirmed it exists, as the root user (so using SUDO) modify the regular user to add them to the group:

    # In this example, the user I am adding is `collid` 
    sudo usermod -aG docker collid

Now, either log out and back into a new terminal (or reboot it) and as that regular (non-root) user, run a simple check:

    docker --version 

If this now returns output, all has been enabled! <br>
Note, the root account likely will be needed to start the docker service, but once it is running, the regular user can run docker CLI without sudo privs

----------------------

## Docker and Airflow

So, we can use Docker to set up & run Airflow locally (with a postgres DB) to allow us to build DAGs & test them, without needing to do loads of installs on our actual machine. <br>
So, having just installed Docker CE above, let's also install `docker-compose` 

    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

Once that has been downloaded and installed, you should be able to check with a simple:

    docker-compose --version 

If that comes back with a succesful output, like: `Docker Compose version v2.23.0` then you are good to go

To start the Airflow journey, we first make an airflow directory and then fetch a docker-compose file from the Apache Airflow docs

    # currently in ./localDevelopment 
    mkdir airflow  # make the directory
    chmod 777 airflow # grant Read & Write to users on it
    cd airflow # switch into it

    # execute curl command to pull copy of the docker-compose file for Airflow 2.3.0
    curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.3.0/docker-compose.yaml'

This will now give you a `docker-compose.yaml` file in your project folder. <br>
Looking inside it will show the different services that have been defined, like:
- airflow-scheduler
- airflow-webserver
- airflow-worker
- airflow-init
- postgres 

etc.

Ok, now in the airflow directory, create some other sub-directories:

    mkdir ./dags ./logs ./plugins

Next, we would have to export an environment variable to ensure that the folder on your host machine and the folders within the containers share the same permissions. We will simply add these variables into a file called `.env`

    echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" > .env

The contents of `.env` should look something like:

    cat .env # prints the contents out
    AIRFLOW_UID=1000
    AIRFLOW_GID=0

With that done, we can now initialise the Airflow database with docker, by starting the `airflow-init` container:

    docker-compose up airflow-init

This essentially runs `airflow db init` as if you had installed Airflow yourself on your host machine. by default, the account created has login user `airflow` and password `airflow`, which is fine for testing purposes. Change these for any actual work/production setup.

Next, we will be able to actually start the airflow services.<br>
We can do this by executing:

    docker-compose up # ensuring you are in the directory where the compose file is 

This may now take a few minutes to start up all the services, but you should eventually see logs to indicate everything is running.<br>
You can also, after a few minutes, open another shell and execute:

    docker ps

This should show the images that are up & running, where you will hopefully see your running airflow services

Once running, you can access the airflow UI in a web browser. Simply fo to *`localhost:8080`* and you will be presented with a sign in page for the airflow UI. Here, you can login as the airflow user with those credentials mentioned above

You should see a load of example DAGs that ship as standard on the homepage, as we didnt exclude these in any configs

in your second terminal, you can also enter the Airflow worker container, so you can access the Airflow CLI. Use the `docker ps` command above to find the container id of the worker service, then:

    # in this format: docker exec -it <container-id> bash
    sudo docker exec -it 937c9f873b95 bash

This will take you into the container and let you use the Airflow CLI, for example:

    default@937c9f873b95:/opt/airflow$ airflow version

    # prints back 2.3.0
    # or 

    default@937c9f873b95:/opt/airflow$ airflow cheat-sheet -v

    # for loads of hints and tips 

    # exit to leave the Airflow worker CLI
    exit

Clean up the resources and pull down the Airflow docker container by:

    docker-compose down --volumes --rmi all

If you then run the `docker ps` command after this has completed, you should see no containers running

And thats the end of the guide for setting up Airflow locally with docker!

----------------------

----------------------

## Docker and Amazon-Linux 2

Given some services may run on AWS Linux 2, on EC2, wanted to explore using Docker to run AWS Linux 2 locally for development. 


