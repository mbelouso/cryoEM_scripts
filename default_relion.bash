#!/bin/bash
# Relion 5.0 Job submission Script
#SBATCH --job-name=Relion
#SBATCH --account=mc12
#SBATCH --partition=ccemmp
# SBATCH --reservation=
#SBATCH --qos=ccemmpq

# Resource Request
#SBATCH --ntasks=XXXmpinodesXXX
#SBATCH --cpus-per-task=XXXthreadsXXX
#SBATCH --nodes=1
#SBATCH --mem=
#SBATCH --time=

# GPU Request
# SBATCH --gres=gpu:

# Set the file for output (stdout)
#SBATCH --output=XXXoutfileXXX

# Set the file for error log (stderr)
#SBATCH --error=XXXerrfileXXX

# Command to run a serial job
module purge
module load relion/5.0-20240320

nvidia-smi
srun hostname
mpirun XXXcommandXXX
echo "done"
