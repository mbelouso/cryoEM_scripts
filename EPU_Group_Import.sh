#!/bin/bash

# Script to import Movies files collected an EPU data collection when you forgot to get the .xml files
# Need to have all the movie files in a single directory
# The movie files should be named in the format as outputed by EPU, e.g.: FoilHole_16759718_Data_13754703_5_20250217_153502_EER.eer (where the optics group is the 5th underscore separated value)
# This script will create a STAR file for each optics group and then combine them into a single STAR file
# Note: you may want to change the amplitude contrast value (ac) depending on your data collection conditions

# Module to load RELION (For our example on M3 Cluster)
module load relion/5.0-20240320

read -p "Enter the path to the directory containing movie files (e.g. Micrographs/): " movie_dir
if [ ! -d "$movie_dir" ]; then
    echo "Directory does not exist: $movie_dir"
    exit 1
fi

read -p "Enter the kV: " kv
read -p "Enter the Pixel Size: " angpix
read -p "Enter the Spherical Abberation (in mm): " Cs
ac=0.07 # Assuming a constant value for the amplitude contrast
read -p "What is the file type (e.g. eer, mrc, tiff, tif)?: " file_type
read -p "Enter the file name of the MTF file (e.g. K3_mtf.star): " mtf_file
if [ ! -f "$mtf_file" ]; then
    echo "MTF file does not exist: $mtf_file"
    exit 1
fi

# Test to see how many Optics groups are in the .eer files:
optics_groups=$(find "$movie_dir" -name "*.$file_type" | awk -F '_' '{print $5}' | sort -u | wc -l)
if [ "$optics_groups" -eq 0 ]; then
    echo "No optics groups found in Movie files."
    exit 1
fi
echo "Found $optics_groups optics groups in Movie files."

# For loop to process each optics group and import into RELION *.star file

mkdir STAR_files

for i in $(seq 0 100); do
    echo "Processing optics group $i..."
    optics_name="OpticsGroup$i"
    eer_pattern="$movie_dir/*_${i}_*.$file_type"
    eer_files=( $eer_pattern )
    if [ ! -e "${eer_files[0]}" ]; then
        echo "No .eer files found for optics group $i"
        continue
    fi
    
	echo $eer_pattern

    relion_import  --do_movies \
        --optics_group_name $optics_name \
        --optics_group_mtf $mtf_file \
        --angpix $angpix \
        --kV $kv \
        --Cs $Cs \
        --Q0 $ac \
        --beamtilt_x 0 --beamtilt_y 0 \
        --i "$eer_pattern" \
        --odir STAR_files/ --ofile movies_$i.star

done

echo "Opticsgroup are imported and saved in the STAR_files directory."

# Use relion to join the star files into a single movies.star

`which relion_star_handler` --combine --i " STAR_files/movies_*.star" --o movies_joined.star

echo "All completed comrade! Be sure to clean up your data!!!!"
