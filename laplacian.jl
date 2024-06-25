using Printf

function lap(in_field::Matrix{Float64})::Matrix{Float64}
    nrows, ncols = size(in_field)
    out_field = [0.0 for _ in 1:nrows, _ in 1:ncols] # Initialize out_field as a matrix of zeros
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
    out_field = lap(in_field)
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
