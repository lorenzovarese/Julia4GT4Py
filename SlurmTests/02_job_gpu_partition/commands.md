
Compile the code:
```shell
nvcc -o vector_add vector_add.cu
```

Execute the job:
```shell
sbatch job_gpu.sh
```

Check the queue with my task:
```shell
squeue -u $USER
```

Inspect the results:
```shell
cat gpu_job.out
```
