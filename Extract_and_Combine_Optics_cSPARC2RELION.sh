#!/bin/bash

# Script to Extract the optics groups from a given STAR file, and then combine them into a single
# file with the same format as the original STAR file, but with the optics groups defined.
# Format of the the data_particles
#data_particles
#
#loop_
#_rlnImageName #1
#_rlnAngleRot #2
#_rlnAngleTilt #3
#_rlnAnglePsi #4
#_rlnOriginXAngst #5
#_rlnOriginYAngst #6
#_rlnDefocusU #7
#_rlnDefocusV #8
#_rlnDefocusAngle #9
#_rlnPhaseShift #10
#_rlnCtfBfactor #11
#_rlnOpticsGroup #12
#_rlnRandomSubset #13
#_rlnClassNumber #14
#000001@J54/extract/009157767845483574648_FoilHole_29471603_Data_29469926_20_20250429_122332_EER_patch_aligned_doseweighted_particles.mrc -72.277634 101.165459 156.961456 0.041231 -1.278169 19099.261719 18988.373047 -13.393326 0.000000 0.000000 3 1 1

# Some basic questions to ask:

read -p "Enter the input STAR file (e.g., run_data.star): " input_star
read -p "Enter the output STAR file (e.g., run_data_optics.star): " output_star

# Run a for loop line by line through the input STAR file
echo "Extracting optics groups from $input_star and saving to $output_star"

mkdir temp_star

# First need to clean up the input STAR file to ensure it works with relion_star_handler
# Need to remove all but on of the optics groups in the data_optics section

relion_star_handler --i "$input_star" --operate rlnOpticsGroup --set_to 1 --o temp_star/cleaned_star.star

for i in $(seq 0 68); do
    echo "Processing optics group $i"
    relion_star_handler --i temp_star/cleaned_star.star \
        --o "temp_star/ptcls_tilt_group$(printf "%04d" $i).star" \
        --select_by_str rlnImageName \
        --select_include _${i}_
done

# Now we have a set of STAR files, one for each optics group, we need to add the optics group name
# Use a for loop to process each file and use sed to edit the optics group name

mkdir -p temp_star/optics

cd temp_star

for j in ptcls_tilt_group*.star; do
    echo "Processing file: $j"
    sed 's/opticsGroup1/'${j%.star}'/' "$j" > "optics/${j%.star}_optics.star"
done

cd ..

# Combine all the individual STAR files into a single STAR file
echo "Combining individual STAR files into $output_star"

relion_star_handler --i " temp_star/optics/*.star" --o "$output_star" --combine

# Clean up temporary files
rm -rf temp_star

echo "Optics groups extraction completed. Output saved to $output_star"