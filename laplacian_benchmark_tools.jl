using BenchmarkTools
include("laplacian.jl")  # Assuming this path is correct and laplacian.jl is in the same directory
using .Laplacian

const suite = BenchmarkGroup()

matrix_sizes = [1000, 2000, 4000]
functions = ["lap", "lap_vectorized", "lap_vectorized_optimized", "lap_vectorized_optimized_simd"]

for size in matrix_sizes
    suite[size] = BenchmarkGroup()
    for func in functions
        suite[size][func] = BenchmarkGroup()
    end
end

for size in matrix_sizes
    in_field = rand(Float64, size, size)  # Create a matrix of the current size

    suite[size]["lap"] = @benchmarkable lap($in_field)
    suite[size]["lap_vectorized"] = @benchmarkable lap_vectorized($in_field)
    suite[size]["lap_vectorized_optimized"] = @benchmarkable lap_vectorized_optimized($in_field)
    suite[size]["lap_vectorized_optimized_simd"] = @benchmarkable lap_vectorized_optimized_simd($in_field)
end

println("Benchmarks execution...")
results = run(suite)  # This will execute all benchmarks

println(results)

## Alternative with @btime
# for size in matrix_sizes
#     # Create a random matrix of size `size x size`
#     in_field = rand(Float64, size, size)

#     # Benchmark each function
#     println("Benchmarking for matrix size $size x $size")
#     println("lap function:")
#     @btime lap($in_field)

#     println("lap_vectorized function:")
#     @btime lap_vectorized($in_field)

#     println("lap_vectorized_optimized function:")
#     @btime lap_vectorized_optimized($in_field)

#     println("lap_vectorized_optimized_simd function:")
#     @btime lap_vectorized_optimized_simd($in_field)
#     println()  # Add a newline for better readability between benchmarks
# end
