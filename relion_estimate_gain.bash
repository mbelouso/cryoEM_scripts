#!/bin/bash
# Relion 3.1 Job submission Script (matthew.belousoff@monash.edu)
#SBATCH --job-name=GainCalc
#SBATCH --account=mc12
#SBATCH --partition=ccemmp
# SBATCH --reservation=sexton
#SBATCH --qos=ccemmpq
# SBATCH --nodelist=m3g006

# Resource Request
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1
#SBATCH --mem=60GB
#SBATCH --time=0-0:10:0

# GPU Request
# SBATCH --gres=gpu:3

# Set the file for output (stdout)
#SBATCH --output=estimate_gain_%j.out

# Set the file for error log (stderr)
#SBATCH --error=estimate_gain_%j.err

# Need to change the input to match your curated star file, probably 100 or so micrographs is more than enough
# NOTE for Motioncor2 and MotionCor3 you need to output as MRC or gain correction doesn't work.
# 
module purge
module load relion/3.1.2

nvidia-smi
srun hostname
relion_estimate_gain --i movies.star --o gain.mrc --j 8 --max_frames 5000 --random

echo "Gain has been calculated comrade, Good hunting!"
