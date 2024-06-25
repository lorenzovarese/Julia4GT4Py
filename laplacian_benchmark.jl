# Include the stencil operations module
include("laplacian.jl")
using .Laplacian

# Test the functions
nrows, ncols = 10000, 10000  # Example dimensions
in_field = rand(Float64, nrows, ncols)  # Randomly generate input field

# Time the loop-based implementation
println("Timing loop-based implementation:")
@time lap(in_field)

# Time the vectorized implementation
println("Timing vectorized implementation:")
@time lap_vectorized(in_field)
