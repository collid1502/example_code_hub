#!/bin/bash

###==============================================
# Finds files in directories & sub-directories 
# splits them by number of lines specified
# writes out the split files to new path 
###==============================================

# check the correct number of arguments have been provided 
if [ "$#" -ne 3 ]; then 
    echo "Usage: $0 <top-level-dir> <output-dir> <line-counts>"
    exit 1
fi 

# assign variables by provided args 
top_level_dir=$1
output_dir=$2
line_count=$3

# create function to split large CSV files 
split_csv_file() {
    local file=$1 
    local line_count=$2 
    local output_dir=$3
    local header=$(head -1 "$file") # extract line 1 as the header 
    local base_name=$(basename "$file" .csv) # get the base name of the file without the `.csv` extension at end 
    local temp_dir=$(mktemp -d) # creates a temp directory 

    # split the file, exclude the header, into parts specified by line counts 
    tail -n +2 "$file" | split --lines $line_count - "${temp_dir}/${base_name}_part_" -d --additional-suffix=.csv 

    # create output directory if it doesn't already exist 
    mkdir -p "$output_dir" 

    # add header into each split file part & move that file to the output dir 
    for part in ${temp_dir}/${base_name}_part_*; do
        local part_file="${output_dir}$(basename "$part").csv" 
        { echo "$header"; cat "$part"; } > "$part_file"
        echo "created part file: $part_file" 
    done

    # clean up temp dir 
    rm -r "$temp_dir" 
    echo "Split $file into multiple parts with header retained into $output_dir" 
}

# Loop over all CSV files found in directory & it's sub-dirs
find "$top_level_dir" -type f -name "*.csv" | while read -r file; do
    echo "Processing $file ..."
    split_csv_file "$file" "$line_count" "$output_dir" 
done 
# end of file 