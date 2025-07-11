#!/bin/bash

# This script is to create a 'correct_micrographs.star' in the RELION format from a cryoSPARC converted .star file.

read -p "Enter the path to the cryoSPARC converted .star file: " input_file
read -p "Enter the path to save the RELION micrograph format .star file: " output_file

# Extract the header up to the 'data_particles' line
awk '/data_particles/ {print; exit} {print}' "$input_file" > header.star

# Replace 'data_particles' with the required header for RELION micrographs
sed -i '/data_particles/ {
    s/data_particles/data_micrographs\n\nloop_\n_rlnMicrographName #1\n_rlnOpticsGroup #2\n/
}' header.star

# Use Relion STAR printable to export the micrographs from the original cryoSPARC .star file
relion_star_printtable "$input_file" data_particles rlnMicrographName rlnOpticsGroup > temp_output.star

# Remove duplicate lines and save to the final output file
sort temp_output.star | uniq > temp_unique.star

# Prepend the header to the output file
cat header.star temp_unique.star > "$output_file"

# Clean up temporary files
rm temp_output.star temp_unique.star header.star

echo "RELION micrograph format .star file created successfully at $output_file"

