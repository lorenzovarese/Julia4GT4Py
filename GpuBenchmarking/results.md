### Compile (on GTX 970 with sm_52 architecture)

[master][~/CSCS/cuda-stream]$ make    
nvcc -std=c++11 -ccbin=g++ stream.cu -arch=sm_52 -o stream

### Results

STREAM Benchmark implementation in CUDA
 Array size (double precision) = 536.87 MB
 using 192 threads per block, 349526 blocks
 output in IEC units (KiB = 1024 B)

Function      Rate (GiB/s)  Avg time(s)  Min time(s)  Max time(s)
-----------------------------------------------------------------
Copy:         132.0126      0.00776656   0.00757504   0.00842214
Scale:        131.9461      0.00777608   0.00757885   0.00902295
Add:          134.7813      0.01145042   0.01112914   0.01240802
Triad:        134.5910      0.01130652   0.01114488   0.01165891
