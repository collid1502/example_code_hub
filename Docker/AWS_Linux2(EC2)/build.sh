# Start docker if not already running (can check status)
# sudo service docker status
sudo service docker start

# use docker to run amazon linux 2 locally 
sudo docker run -it amazonlinux:2

# This will pull an image, and then spawn a Shell to execute commands in as if on EC2
# with AWS Linux 2 as the distro.
# ----------------------------------------------------------------------------
##
## NOW - you are on the AWS Linux 2 command line running inside the container 

# check for updates 
yum check-update 

# check for Python3
yum list installed | grep -i python3

# if not found, install it!!
yum install python3 -y

## Looking to install conda virtual environment manager (through Miniconda)
# ensure you are in the home directory 
cd ~

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