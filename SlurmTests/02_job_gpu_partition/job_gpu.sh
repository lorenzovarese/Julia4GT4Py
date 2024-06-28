#!/bin/bash -l
#SBATCH --job-name=gpu_job
#SBATCH --account=csstaff
#SBATCH --partition=normal
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --gres=gpu:1
#SBATCH --output=gpu_job.out
#SBATCH --error=gpu_job.err
#SBATCH -C gpu

# Load necessary modules
module load PrgEnv-cray
module load cray-mpich
module load gcc
module load cudatoolkit

# Run your application
srun ./vector_add