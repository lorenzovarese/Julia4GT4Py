# Internship Introduction Overview 🔍

Welcome to the repository for the internship program. This README outlines the key tasks and projects undertaken during the internship, providing guidance and resources for future interns.

## Getting Started

Before diving into the projects, ensure your development environment is set up correctly:

1. **Install Julia and VSCode:**
   - Download and install Julia from the [official website](https://julialang.org/downloads/).
   - Install Visual Studio Code (VSCode) from [here](https://code.visualstudio.com/).
   - Set up the Julia extension and the Julia debugger in VSCode for efficient coding and debugging.

2. **Understanding Julia:**
   - Get familiar with Julia's REPL; use `;` for shell access and `]` for package management.
   - Explore the [Julia documentation](https://docs.julialang.org/en/v1/) to understand basics and advanced features.

3. **Environment Setup on Piz Daint:**
   - Connect to Piz Daint via VPN and setup authentication as per the [CSCS guide](https://user.cscs.ch/access/auth/mfa/).
   - Learn to manage jobs on SLURM; refer to the [CSCS user guide](https://user.cscs.ch/access/running/).
   - Install necessary software using Spack as specified in the provided `spack.yaml` environment file.

## Project Descriptions

### Laplacian Implementations

- **Files:**
  - `laplacian.jl`: Basic implementation of Laplacian in Julia.
  - `laplacian_benchmark.jl`: Benchmarking script for Laplacian performance.
  - `laplacian_benchmark_tools.lj`: Tools and utilities for benchmarking.

- **Tasks:**
  - Explore the Laplacian operation using GT4Py by reviewing the [integration test example](https://github.com/GridTools/gt4py/blob/main/tests/next_tests/integration_tests/multi_feature_tests/ffront_tests/test_laplacian.py).
  - Implement and benchmark the Laplacian in Julia, following guidance from the Julia [arrays manual](https://docs.julialang.org/en/v1/manual/arrays/) and [benchmarking tools](https://github.com/JuliaCI/BenchmarkTools.jl).

### Macro Programming and Metaprogramming in Julia

- **Files:**
  - `macro_derivative.jl`: Implementations of derivative macros.
  - `metaprog_tutorial.ipynb`: Jupyter notebook with tutorials on metaprogramming.

- **Tasks:**
  - Develop a generated function that dispatches at compile time and verify with `@code_llvm`.
  - Create a derivative macro that computes the derivative expression of algebraic expressions.
  - Utilize tools like MacroTools for complex macro operations, available [here](https://github.com/FluxML/MacroTools.jl).

### Integration with Other Languages

- **Tasks:**
  - Use PyCall to integrate and debug Python packages within Julia.
  - Run CUDA operations in Julia on Piz Daint, familiarizing with GPU computing.

### Advanced Optimization Techniques

- **Files:**
  - `inline_outbounds.jl`: Demonstrations of `@inline` and `@inbounds` optimizations in Julia.

- **Tasks:**
  - Apply advanced Julia optimization flags to improve performance. (TODO)
  - Explore embedded GPU backend possibilities with GridTools.jl and related compiler optimizations. (TODO)

## Configuration

See the [`configuration.md`](/configuration.md).

## Additional Resources

- **SLURM Job Management:** [SLURM Documentation](https://slurm.schedmd.com/documentation.html)
- **Julia Performance Tips:** [Julia Performance](https://docs.julialang.org/en/v1/manual/performance-tips/)
- **CSCS Python Environment Setup:** [Python at CSCS](https://user.cscs.ch/tools/interactive/python/)

## Conclusion

This repository serves as a comprehensive guide to the introductory tasks completed during the internship. Future interns are encouraged to use this documentation as a starting point for their work and explore further optimizations and features.
