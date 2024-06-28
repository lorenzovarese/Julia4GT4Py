
Compile the code:
```shell
gcc -o multicore_app multicore_app.c -fopenmp
```

Execute the job:
```shell
sbatch job_multicore.sh
```

Check the queue with my task:
```shell
squeue -u $USER
```

Inspect the results:
```shell
cat multicore_job.out
```
