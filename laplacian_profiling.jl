# Include the stencil operations module
include("laplacian.jl")
using .Laplacian
using Profile
using ProfileView

# Define the test dimensions and generate the test field
nrows, ncols = 10000, 10000  # Large dimensions for significant profiling data
in_field = rand(Float64, nrows, ncols)  # Randomly generate input field

# Function to profile each implementation
function profile_laplacian(func, in_field)
    println("Profiling ", func)
    Profile.clear()  # Clear previous profiling data
    @profile (for i in 1:10  # Run multiple times to gather more comprehensive data
        func(in_field)
    end)
    Profile.print()  # Print the profiling results
end

# Profile each implementation
profile_laplacian(lap, in_field)
profile_laplacian(lap_vectorized, in_field)
profile_laplacian(lap_vectorized_optimized, in_field)
