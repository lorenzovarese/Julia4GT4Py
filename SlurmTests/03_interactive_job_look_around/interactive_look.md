
### Execute an Interactive Job and "Look Around"

To run an interactive job and explore the node, use `srun`:

Note: When you launch an interactive job using srun, SLURM allocates resources on a compute node (e.g., nid00047), which is different from the login node (daint104). This is the expected behavior since srun is designed to run tasks on compute nodes.

- Login Node (daint104): This is where you connect initially and submit your jobs. It's not meant for heavy computations.
- Compute Node (nidXXXX): These nodes are where your jobs run. When you use srun, you are allocated a compute node where your interactive session is executed.

SLURM is designed to separate job submission from job execution to efficiently manage resources and ensure that computationally intensive tasks do not overload the login nodes.

#### Multicore Partition

```bash
srun -A csstaff -C mc --time=2:00:00 --ntasks=1 --cpus-per-task=36 --pty bash
```

#### GPU Partition

```bash
srun -A csstaff -C gpu --time=2:00:00 --ntasks=1 --cpus-per-task=12 --gres=gpu:1 --pty bash
```

Once inside the interactive session, you can check the number of cores and GPU status:

```bash
lscpu  # Check CPU details
nvidia-smi  # Check GPU details
```
