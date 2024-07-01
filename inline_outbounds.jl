using Pkg
Pkg.add("BenchmarkTools")
using BenchmarkTools
using Random

# Inline test

@inline function in_long_addition(x::Int64,y::Int64):Int64
    x = x * x
    y = y * y * x
    x = y - x
    return x + y
end

@noinline function long_addition(x::Int64,y::Int64):Int64
    x = x * x
    y = y * y * x
    x = y - x
    return x + y
end

# Define a local variable for 'a' to avoid scope issues
local a

a = 0

@time for i in 1:1000000
    global a
    a += long_addition(1000000000, 1000000030 + i*21)
end

a = 0

@time for i in 1:1000000
    global a
    a += in_long_addition(100000000, 100000003 + i*21)
end

# @inbounds: Eliminates array bounds checking within expressions

function sum(A::AbstractArray)
    r = zero(eltype(A))
    for i in eachindex(A)
        r += A[i]
    end
    return r
end

function ib_sum(A::AbstractArray)
    r = zero(eltype(A))
    for i in eachindex(A)
        @inbounds r += A[i]
    end
    return r
end

function generate_random_array(n::Int)
    # Generate an array of n random floating-point numbers between 0 and 1
    random_array = rand(n)
    return random_array
end

# Generate random array
rand_array = generate_random_array(1000)

local s

# Benchmark sum using @time
s = 0
@time for i in 1:1000000
    global s
    s += sum(rand_array)
end

# Benchmark ib_sum using @time
s = 0
@time for i in 1:1000000
    global s 
    s += ib_sum(rand_array)
end

# TODO: wrap it in a function and check the performance difference (to avoid access to the global)

# BenckmarkTools alternative

benchmark_sum = @benchmark begin
    s = 0
    for i in 1:1000000
        s += sum(rand_array)
    end
end

benchmark_ib_sum = @benchmark begin
    s = 0
    for i in 1:1000000
        s += ib_sum(rand_array)
    end
end

# Display results
display(benchmark_sum)
display(benchmark_ib_sum)
