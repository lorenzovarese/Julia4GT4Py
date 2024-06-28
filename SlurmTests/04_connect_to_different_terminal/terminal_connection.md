### Execute a Job and Connect via SSH to the Compute Node

To execute a job and then connect to the compute node, follow these steps:

#### Job Script for SSH Connection

Create a job script `job_with_ssh.sh`:

```bash
#!/bin/bash -l
#SBATCH --job-name=ssh_job
#SBATCH --account=csstaff
#SBATCH --partition=normal
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --gres=gpu:1
#SBATCH --output=ssh_job.out
#SBATCH --error=ssh_job.err
#SBATCH -C gpu

# Print the node name to the output file and a separate file
echo "Running on node $(hostname)" | tee node_name.txt

# Keep the job alive for SSH connection
sleep 1h
```

Submit the job:

```bash
sbatch job_with_ssh.sh
```

Monitor the job status and get the node name:

```bash
squeue -u $USER
cat node_name.txt  # After the job starts, this file will contain the node name
```

#### SSH into the Compute Node

Once you have the node name (e.g., `nidXXXXX`), open another terminal and SSH into the node:

```bash
ssh nidXXXXX  # Replace 'nidXXXXX' with the actual node name
```

Here the complete output in the new terminal:
```shell
❯ ssh -A lvarese@daint.cscs.ch
Last login: Thu Jun 27 16:59:19 2024 from 148.187.134.73
  =========================================================================
               IMPORTANT NOTICE FOR USERS of CSCS facilities
      Documentation: CSCS User Portal - https://user.cscs.ch
      Request support: https://support.cscs.ch
  =========================================================================
Please use one of the following commands:
- 'module load daint-gpu' to access the gpu software stack
- 'module load daint-mc' to access the multicore software stack
Submit your jobs with '-C gpu' for gpu nodes or '-C mc' for multicore nodes
For more details please refer to https://user.cscs.ch/access/running/piz_daint

lvarese@daint106:~> ssh nid05212

*** Welcome to IMPS compute node c7-2c0s7n0 (nid 5212) ***
    Running 1.3GB Suse 15.2 image cscs_compute_netroot_cle_7.0.up03_sles_15sp2
    CLE release 7.0.UP03, build 7.0.3410(20220314)
    24 vcores, boot_freemem: 61204mb

lvarese@nid05212:~>
```

#### Extend the Time of the Job

Identify the JobID:
```bash
squeue -u $USER
```

Update the job time with `scontrol`:
```bash
scontrol update JobId=<job_id> TimeLimit=03:00:00
```

#### Interrupt a Job

Use `scancel` with the JobID:
```bash
scancel <job_id>
```

If you want to cancel all jobs submitted by you:
```bash
scancel -u $USER
```
