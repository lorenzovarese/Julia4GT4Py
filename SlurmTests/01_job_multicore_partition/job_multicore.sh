#!/bin/bash -l
#SBATCH --job-name=multicore_job
#SBATCH --account=csstaff
#SBATCH --partition=normal
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=36
#SBATCH --output=multicore_job.out
#SBATCH --error=multicore_job.err
#SBATCH -C mc

# Load necessary modules
module load PrgEnv-cray
module load cray-mpich

# Run your application
srun ./multicore_app