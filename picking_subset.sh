#!/bin/bash

# Written by Matt B (matthew.belousoff@monash.edu)
# Script for setting up a subset of micrographs for crYOLO training
# First create a subset job in RELION and figure out what the job number is
# Make sure the relion module is loaded and your are in the root directory of your relion project.

# Useage:
# bash ./picking_subset.sh RELION_SUBSET_JOB_NUMBER
# e.g.
# bash ./picking_subset.sh 004

SUBSET=$1

relion_star_printtable Select/job${SUBSET}/micrographs_split1.star data_micrographs rlnMicrographName > mics.txt

mkdir Picking_Subset
mkdir Picking_Subset/Micrographs

xargs -a mics.txt cp -t Picking_Subset/Micrographs

rm mics.txt

echo "All Finished Comrade"

