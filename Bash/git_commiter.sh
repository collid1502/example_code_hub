# typical commands for working with git from command line in Linux 

# change to existing project folder ]
cd /my/dummy/project 

git init  # initiates empty git repo in folder location 
git add -all  # adds all files in this directory to git for tracking 
git commit -m "commit message for this commitment" 

git remote add origin <PASTE_URL_OF_REMOTE_ORIGIN>  # link to remote repo location like github 

git push -u origin master  # pushes commit to the Master branch on your repo 

git add dummyFile.sh   # adds a new file for git to track 

git commit -a  # commit any files you have added with `git add` and any file changes since last commit 

git status   # check git status 

git checkout -b <ENTER_BRANCH_NAME_HERE>  # create a new branch of repo & switch to it 

git checkout <BRANCH_NAME>   # switch from one branch to another 

git branch  # list all branches in repo 

git push origin <BRANCH_NAME>  # push branch to remote repo for others to use 
