#!/bin/bash
# Simply copy Script into Base folder  from L120C data collection and run it
# DO NOT USE SPACES IN YOUR FILE NAMES

mkdir Micrographs
mv *.ser ./Micrographs
rm *.emi
cd Micrographs
conda activate eman2
e2proc2d.py *.ser @.mrc
conda deactivate

echo "All Finished Comrade, good hunting"




