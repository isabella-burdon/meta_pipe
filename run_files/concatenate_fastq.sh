#!/bin/bash

# Define the root directory
root_directory="/Users/issyburdon/Library/CloudStorage/Box-Box/meta_pipe/a_rawReads"

# Define the output directory
output_directory="/Users/issyburdon/Library/CloudStorage/Box-Box/meta_pipe/a_readsConcat"

# Go into the root directory
cd "$root_directory" || exit 1

# Loop through each subdirectory in the root directory
for folder in */; do
    # Extract the folder name
    folder_name=$(basename "$folder")

    # Concatenate the files in the current folder and output to the specified directory
    cat "${root_directory}/${folder_name}"/*.fastq.gz > "${output_directory}/${folder_name}.fastq.gz"
done

echo "Concatenation complete!"

# to make executable: chmod +x concatenate_fastq.sh
# to run: ./concatenate_fastq.sh
