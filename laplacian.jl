module Laplacian

export lap, lap_vectorized, lap_vectorized_optimized

using LinearAlgebra, Printf

function lap(in_field::Matrix{Float64})::Matrix{Float64}
    nrows, ncols = size(in_field)
    out_field = zeros(Float64, nrows, ncols) # Initialize out_field as a matrix of zeros
    out_field .= in_field # Copy inplace: to keep the initial values in the border
    for i in 2:(nrows - 1)
        for j in 2:(ncols - 1)
            # Perform the stencil operation
            out_field[i, j] = -4 * in_field[i, j] + 
                                in_field[i+1, j]   + 
                                in_field[i-1, j]   + 
                                in_field[i, j+1]   + 
                                in_field[i, j-1]
        end
    end

    return out_field
end

function lap_vectorized(in_field::Matrix{Float64})::Matrix{Float64}
    nrows, ncols = size(in_field)
    out_field = zeros(Float64, nrows, ncols)
    out_field .= in_field # Copy inplace: to keep the initial values in the border
    # Vectorized operations (with slicing)
    out_field[2:end-1, 2:end-1] = -4 * in_field[2:end-1, 2:end-1] +
                                    in_field[3:end, 2:end-1]   +  # i+1
                                    in_field[1:end-2, 2:end-1] +  # i-1
                                    in_field[2:end-1, 3:end]   +  # j+1
                                    in_field[2:end-1, 1:end-2]    # j-1

    return out_field
end

function lap_vectorized_optimized(in_field::Matrix{Float64})::Matrix{Float64}
    nrows, ncols = size(in_field)
    out_field = zeros(Float64, nrows, ncols)
    out_field .= in_field

    # Prepare shifted arrays by slicing without creating new arrays
    north = @view in_field[1:end-2, 2:end-1] # Shift up (1 row)
    south = @view in_field[3:end, 2:end-1] # Shift down (1 row)
    west = @view in_field[2:end-1, 1:end-2] # Shift left (1 col)
    east = @view in_field[2:end-1, 3:end] # Shift right (1 col)

    # Calculate using views to avoid extra allocations
    @. out_field[2:end-1, 2:end-1] = -4 * in_field[2:end-1, 2:end-1] + north + south + west + east

    return out_field
end

function laplap(in_field::Matrix{Float64})::Matrix{Float64}
    return lap(lap(in_field))
end

function lap_program(in_field::Matrix{Float64}, out_field::Matrix{Float64})::Nothing
    nrows, ncols = size(in_field)
    for i in 2:(nrows - 1)
        for j in 2:(ncols - 1)
            # Perform the stencil operation
            out_field[i, j] = -4 * in_field[i, j] + 
                                      in_field[i+1, j] + 
                                      in_field[i-1, j] + 
                                      in_field[i, j+1] + 
                                      in_field[i, j-1]
        end
    end
    #The out_field have been changed, but the values in the border remain the same
    return nothing
end

function laplap_program(in_field::Matrix{Float64}, out_field::Matrix{Float64})::Nothing
    temp_field = laplap(in_field)  # Perform the laplap operation on the entire field
    out_field[3:end-2, 3:end-2] .= temp_field[3:end-2, 3:end-2]
    return nothing
end

function pretty_print_matrix(mat::Matrix)::Nothing
    max_width = maximum(length(string(e)) for e in mat)

    for row in eachrow(mat)
        formatted_row = join([@sprintf("%*s", max_width, string(x)) for x in row], "  ")
        println(formatted_row)
    end
    return nothing
end

function allocate_cartesian_case()::Matrix{Float64}
    return [Float64((i-1) * 10 + j-1) for i in 1:10, j in 1:10]
end

# Test Cases (on a manually defined 10x10 matrix (0..99))
function test_laplacian_operations()
    # Create a 10x10 matrix populated with values from 0 to 99 using an array comprehension
    in_field = allocate_cartesian_case()
    
    # Print the original matrix
    println("Original in_field Matrix:")
    pretty_print_matrix(in_field)
    
    # Apply the laplacian operation using the non-in-place version
    out_field = lap_vectorized_optimized(in_field)
    println("\nOutput Matrix after applying lap function:")
    pretty_print_matrix(out_field)
    
    # Apply the laplacian operation using the in-place version
    out_field_program = allocate_cartesian_case()
    lap_program(in_field, out_field_program)
    println("\nOutput Matrix after applying lap_program function:")
    pretty_print_matrix(out_field_program)

    # Apply the laplacian operation twice using the non-in-place version
    out_field_double = laplap(in_field)
    println("\nOutput Matrix after applying laplap function:")
    pretty_print_matrix(out_field_double)
    
    # Apply the laplacian operation twice using the in-place version
    out_field_program = allocate_cartesian_case()
    laplap_program(in_field, out_field_program)
    println("\nOutput Matrix after applying laplap_program function:")
    pretty_print_matrix(out_field_program)
end

# Call the test function
test_laplacian_operations()

end # Module's end