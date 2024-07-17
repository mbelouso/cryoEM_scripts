#!/bin/bash

# running using sh script name
# run with four input parameters: 1. threshold 2. expansion 3. soft edge 4. filename input map 

e2proc3d.py "$4" "${4/.mrc/_mask_th$1_ns$2_ngs$3.mrc}" --process=mask.auto3d:threshold=$1:nshells=$2:nshellsgauss=$3:return_mask=true:radius=200 --process=threshold.clampminmax:minval=0:maxval=1


