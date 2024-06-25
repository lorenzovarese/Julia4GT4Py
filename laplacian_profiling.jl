# Include the stencil operations module
include("laplacian.jl")
using .Laplacian
using Profile
using PProf
using ProfileView

# Define the test dimensions and generate the test field
nrows, ncols = 1000, 1000  # Large dimensions for significant profiling data
in_field = rand(Float64, nrows, ncols)  # Randomly generate input field

# Function to profile each implementation
function profile_laplacian(func, in_field)
    println("Profiling ", func)
    Profile.Allocs.clear()
    Profile.clear()
    @pprof (for i in 1:10  # Run multiple times to gather more comprehensive data
        func(in_field)
    end)
    # For macOS
    run(`open http://localhost:57599`) # MacOS

    # run(`start http://localhost:57599`) # Linux
    # run(`xdg-open http://localhost:57599`) # Windows
    sleep(2)
end

# Profile each implementation
profile_laplacian(lap, in_field)
profile_laplacian(lap_vectorized, in_field)
profile_laplacian(lap_vectorized_optimized, in_field)
profile_laplacian(lap_vectorized_optimized_simd, in_field)
