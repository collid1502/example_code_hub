# snowCLI doesn't support recursion, so we use Python & SnowCLI as a work around to achieve this
# Note, you will need snowcli installed on the machine this runs 

# imports 
import os 
import subprocess
import glob

root_dir = "C:\\my\\file\\path"
dir_process_list = [] # initialise empty list that we will add folder paths to for SnowCLI PUT statements 
for dirpath, subdirs, files in os.walk(root_dir):
    # check if any of the files are .CSV, if so, keep this dirpath 
    for file in files:
        if file.upper().endswith('.CSV'): # means a file contains .csv as its extension 
            dir_process_list.append(dirpath) # add directory path to master list 
            break # we no longer need to check any files in this subdir, as at least 1 CSV has been found 

# now, with the process list, we can begin uploading to an internal stage we have
try:
    for dir in dir_process_list:
        use_dir = dir.replace('\\', '\\\\') # will fully escape backslahses for windows paths 
        # build the cmd command that should be executed. Note, -c is the connection option, and `main` tells snowsql use the main conn details from profile config file
        # -q is teh query option, which you pass inside quotes 
        cmd = f'snowsql -c main -q "PUT file://{use_dir}\\\\*.csv @INTERNAL_STAGE.SUBFOLDER PARALLEL = 10 AUTO_COMPRESS = FALSE OVERWRITE = TRUE"'
        subprocess.run(cmd, shell=True) # execute the above cmd via sub-process 
        print(f"Loading files from {dir} to INTERNAL STAGE Complete")
except Exception as e:
    print(e)
    exit(1) # exit with error code to end batch process 

# end 
exit(0) 