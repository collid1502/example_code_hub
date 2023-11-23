# Docker & Amazon Linux 2

Start docker if not already running (can check status)
```
# sudo service docker status

sudo service docker start
```

use docker to run amazon linux 2 locally 

```
sudo docker run -it amazonlinux:2
```

 This will pull an image, and then spawn a Shell to execute commands in as if on EC2
 with AWS Linux 2 as the distro.

 once on the command line, use :
```
yum check-update 
```

 to look for available updates

-------------

### Check out is Python3 already installed? If not, install it!

You can simply execute:<br>
```
yum list installed | grep -i python3
```
to see if `Python 3` is installed. <br>
If it isn't, you will get a message back:

`bash: python3: command not found`

You can install it by executing: <br>

```
yum install python3 -y
```

Once that has been completed, you can start a Python interactive shell with:

```
python3
```

You can use the standard Python3 interactively as if on your own machine! 

------

### Python virtual environments on EC2

Now, we could just use the standatd `venv` environment manager and pip install our packages etc. However, once downside to this would be if needing multiple environments with different Python versions!

As such, let's practice installing Miniconda (a lightweight Anaconda) to manage our virtual environments! 

step one, ensure you are in the `home` directory
```
cd ~
```
Once there, you can excute the following code:
```
# create a new directory called miniconda3
mkdir -p ~miniconda3

# check if you have `wget` installed
wget --version

# if not, install it with
yum update
yum install wget

# we will now use wget to pull the latest miniconda install file, and save a copy locally
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh

# once downloaded, let's execute the install script
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3

# you can then clean up the install script
rm -rf ~/miniconda3/miniconda.sh

# now, initialise the newly installed miniconda for your shell
~/miniconda3/bin/conda init bash

# you'll need to `reset` your sheel here, so execute
source ~/.bashrc

# you should now see `(base)` in brackets before the command line, which indicates teh base conda environment is active

# let's now quickly test creating a virtual environment with Python 3.8, which I will call `dmc38`. I'll include Pandas for this example, as well as installing PIP
conda create -n dmc38 python=3.8 pip pandas

# once complete, test by activating the environment
conda activate dmc38

# spawn an interactive Python 3 shell
python
```

Now, you will see a Python shell start with a 3.8.x version of Python. In that shell you can run a test, like importing Pandas to see whether it has worked as expected!

```
import pandas as pd 

# if that has worked, exit the shell
exit() 
```

So, as you can see, we now have the conda environment manager on our EC2 instance (well, practiced via a Docker container) and have built a Python 3.8 virtual environment!

---------------

## Stopping the docker container(s)

You can just type `exit` to leave the AWS linux 2 command line. <br>
You can also check what containers are running in Docker by: <br>

```
docker ps
```

Should return no running container once exited from the AWS Linux 2 shell.

You can then all stop the docker service with:
```
sudo service docker stop
```

Note, none of the above will have been saved anywhere. If you were to restart the AWS Linux 2 image, you would need to run all the above code again at this point ... 