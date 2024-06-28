#!/bin/bash -l
#SBATCH --job-name=julia_cuda_job
#SBATCH --account=csstaff
#SBATCH --partition=normal
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --gres=gpu:1
#SBATCH --output=julia_cuda_job.out
#SBATCH --error=julia_cuda_job.err
#SBATCH -C gpu

# Load necessary modules
module load PrgEnv-cray
module load cray-mpich
module load gcc
module load cudatoolkit

# Load Julia from Spack
spack load julia

# Run your Julia application
srun julia hello_cuda.jl
