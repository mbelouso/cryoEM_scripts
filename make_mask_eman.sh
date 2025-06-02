#!/bin/bash

# Script to make the best masks in cryoEM 
# Run with the command:
# ./make_mask_eman.sh map_to_binarise.mrc

module purge
module load eman/2.99

read -p "What threshold value:" threshold
read -p "What map expansion (pixels):" expand
read -p "What soft edge (pixels):" softedge

e2proc3d.py "$1" "${1/.mrc/_mask_th${threshold}_ns${expand}_ngs${softedge}.mrc}" --process=mask.auto3d:threshold=$threshold:nshells=$expand:nshellsgauss=$softedge:return_mask=true:radius=200 --process=threshold.clampminmax:minval=0:maxval=1

echo "Mask made, I hope you didn't make it too tight!"
