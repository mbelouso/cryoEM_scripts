#!/bin/bash

# Written by Brian P. Cary, 2022; MIPS
#run with two input parameters: 1. cryosparc_particles.cs file 2. previous relion export job number e.g. "001".
# Note: This does not work with Polish Jobs, will need to modify script.
# Example 
# bash ./csparc_to_relion.bash cryosparc_P66_J38_003_particles.cs 009
# Where 009 corresponds to Extract/job009 (where the original particles came from)

#purge and load appropriate modules
module purge
module load pyem/v0.5

echo "done loading modules"

#run csparc2star, output file
csparc2star.py $1 "${1/.cs/_from_sparc.star}" 

echo "done csparc2star"

#edit the new file
sed -i -e 's/[0-9]*_FoilHole/FoilHole/g' "${1/.cs/_from_sparc.star}"

echo "done sed 1"


#replace J1/imported with Extract/job026/Raw_data or whatever extract job was used to import into cryosparc
sed -i -e 's;J[0-9]*/imported;Extract/job'"$2"'/Micrographs;g' "${1/.cs/_from_sparc.star}"

echo "done sed 2"

#run star.py
star.py --copy-micrograph-coordinates Extract/job"$2"/particles.star "${1/.cs/_from_sparc.star}" "${1/.cs/temp_from_sparc_coordinates.star}"

echo "done star dot py"

#clean up intermediate file
rm "${1/.cs/_from_sparc.star}"

echo "removed intermediate file"

#delete header from coordinates.star
sed -i -e '/data_optics/,/data_particles/d' "${1/.cs/temp_from_sparc_coordinates.star}"

#copy header from particles.star
sed -n '/data_optics/,/data_particles/p' Extract/job"$2"/particles.star > "${1/.cs/_from_sparc_coordinates.star}"

#concatenate
cat "${1/.cs/temp_from_sparc_coordinates.star}" >> "${1/.cs/_from_sparc_coordinates.star}"

echo "copied header"

#clean up intermediate file
rm "${1/.cs/temp_from_sparc_coordinates.star}"
echo "removed intermediate file"

module purge
echo "File Converted"









