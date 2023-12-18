#!/bin/bash

###==============================================
# Finds files in directories & sub-directories 
###==============================================

# specify directory to start searching from -- example: /c/myDir/to/search
rootDir="$1" # take input argument one as the root directory to search from 
cd $rootDir # change to that directory 

# ---------------------------------------------------------------------------
# uses input argument 2 as the file pattern to search for, for example : abc_*.csv
filePattern="$2"
find . -type f -name $filePattern -print0 | while IFS= read -r -d '' file; do
    echo "$file" 
    # add any other processing per file you need to do ...
done 
# end of script 