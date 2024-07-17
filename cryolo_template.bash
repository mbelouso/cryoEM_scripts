#!/bin/bash

# General Submission Script for crYOLO

#SBATCH --partition=ccemmp
#SBATCH --account=mc12
#SBATCH --qos=ccemmpq
#SBATCH --time=0-6:00:0
#SBATCH --ntasks=XXX_SXMPI_NPROC_XXX
#SBATCH --ntasks-per-node=20
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:4
#SBATCH --job-name=XXX_SXMPI_JOB_NAME_XXX
#SBATCH --mem=80GB
#SBATCH --nodes=1
#SBATCH --constraint=r9

# Set the file for output (stdout)
#SBATCH --output=cryolo-%j.out

# Set the file for error log (stderr)
#SBATCH --error=cryolo-%j.err

module load cryolo/1.9.3
nvidia-smi
srun hostname

XXX_SXCMD_LINE_XXX
