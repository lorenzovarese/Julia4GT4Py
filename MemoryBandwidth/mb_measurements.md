
## Measure the memory bandwidth on my local machine

### Install Spack
Install the [spack package manager](https://spack-tutorial.readthedocs.io/en/latest/tutorial_basics.html#):
```bash
git clone https://github.com/spack/spack.git
cd spack
source share/spack/setup-env.sh
```

### Install Stream (with advice for MacOS and Arm)
Try to install `stream` directly:
```bash
spack install stream
```

If there is a problem in compilation, it could be due to the preinstalled clang compiler on mac. You can fix it installing and selecting the correct compiler.

- Install gcc:
```bash
brew install gcc
```

- Check if gfortran is present:
```bash
which gfortran
```

- Update the compiler list that is visibile by spack.
```bash
# Automatically
spack compiler find

# Manually
spack config edit compilers
```

- Now you can move on, and try to install `stream` again.
```bash
spack install stream
```

- If the error persist, you can specify the compiler.
```bash
spack install stream %gcc@14.1.0 # Edit with your gcc version
```

### Run `stream` benchmark

1. Activate the spack environment
```bash
. /opt/homebrew/Cellar/spack/0.22.1/share/spack/setup-env.sh # Adjust with your path
```

2. Load `stream` in your current spack environment:
```bash
spack load stream
```

3. Execute the benchmark:
```bash
stream_c.exe
```

4. Inspect the results printed on screen. Here an example on my local machine:
```
-------------------------------------------------------------
STREAM version $Revision: 5.10 $
-------------------------------------------------------------
This system uses 8 bytes per array element.
-------------------------------------------------------------
Array size = 10000000 (elements), Offset = 0 (elements)
Memory per array = 76.3 MiB (= 0.1 GiB).
Total memory required = 228.9 MiB (= 0.2 GiB).
Each kernel will be executed 10 times.
 The *best* time for each kernel (excluding the first iteration)
 will be used to compute the reported bandwidth.
-------------------------------------------------------------
Your clock granularity/precision appears to be 1 microseconds.
Each test below will take on the order of 3224 microseconds.
   (= 3224 clock ticks)
Increase the size of the arrays if this shows that
you are not getting at least 20 clock ticks per test.
-------------------------------------------------------------
WARNING -- The above is only a rough guideline.
For best results, please be sure you know the
precision of your system timer.
-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:          104841.2     0.001958     0.001526     0.002229
Scale:          90958.1     0.002136     0.001759     0.002379
Add:            90289.1     0.003187     0.002658     0.003495
Triad:          90908.8     0.003153     0.002640     0.003530
-------------------------------------------------------------
Solution Validates: avg error less than 1.000000e-13 on all three arrays
-------------------------------------------------------------
```

### Simple Explanation
Here's a breakdown of the key components and how to interpret these results:

#### **Benchmark Information**
- **STREAM version 5.10**: This indicates the specific version of the STREAM benchmark that was run.
- **Array size**: The benchmark uses arrays containing 10,000,000 elements. Each element uses 8 bytes.
- **Memory per array**: Each array occupies 76.3 MiB (approximately 0.1 GiB). The total memory used for all arrays combined is 228.9 MiB (0.2 GiB).
- **Kernel execution**: Each kernel operation is executed 10 times, and the best time (excluding the first iteration) is used for bandwidth computation.

#### **Timing and Granularity**
- **Clock granularity/precision**: The timer used has a granularity of 1 microsecond, meaning the smallest time interval it can measure is 1 microsecond.
- **Test duration**: Each test takes about 3224 microseconds. The recommendation is to increase array sizes if the test duration is too short (under 20 clock ticks) to ensure accuracy.

#### **Bandwidth Results**
- **Copy**: The system achieved a memory bandwidth of 104,841.2 MB/s while copying data from one array to another. This is often indicative of how quickly the system can handle straightforward memory-to-memory data transfers.
- **Scale**: Achieved a bandwidth of 90,958.1 MB/s for scaling an array by a scalar. This operation involves reading data, multiplying it by a constant, and writing the result back.
- **Add**: The addition of two arrays yielded a bandwidth of 90,289.1 MB/s. This operation is more complex as it involves reading two data sources and writing the result.
- **Triad**: Similar to the add operation but includes a scaling step, resulting in a slightly different bandwidth of 90,908.8 MB/s.

#### **Validation and Error Checking**
- **Solution Validates**: The results indicate that the average error across the operations was less than $(1 \times 10^{-13})$, which means the calculations were performed accurately within the precision limits of the hardware.

#### **Interpretation**
- The results demonstrate that the system can handle large-scale data operations very efficiently. The memory bandwidth values are quite high, suggesting that for applications requiring heavy data transfer or manipulation (like simulations, large-scale computations, or handling large databases), the system should perform well.
- The consistency across operations (Copy, Scale, Add, Triad) with slight variations in performance can be attributed to the additional computational overhead in some operations (like Add and Triad).
- **Copy** operation showing the highest bandwidth indicates optimal performance in direct memory transfer without additional computational overhead.