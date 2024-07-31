using BenchmarkTools, Statistics

function estimate_bandwidth()
    a = rand(Int, 10000000); b = rand(Int, 10000000);
    # Calculate the size of data processed
    data_size = sizeof(a) + sizeof(b)  # Total bytes processed
    println("Total size: ", data_size / 1e6, " MB") # --> 160 MB if both a and b have 10 millions integer

    bench = @benchmarkable $a .+ $b
    results = run(bench)

    # Calculate bandwidth: total bytes processed / time in seconds (for the culmulative statistics)
    time_in_seconds = minimum(results.times) / 1e9  # convert ns to s --> Optimistic case (switch with `median`)
    bandwidth = data_size / time_in_seconds / 1e9  # GB/s

    
    println("Best Rate MB/s: ", bandwidth * 1e3)
    println("Avg time: ", mean(results.times) / 1e9)
    println("Min time: ", minimum(results.times) / 1e9)
    println("Max time: ", maximum(results.times) / 1e9)
    println()
    
    # Calculate bandwidth: total bytes processed / time in seconds (for the culmulative statistics)
    time_in_seconds = minimum(results.times) / 1e9  # convert ns to s --> Optimistic case (switch with `median`)
    bandwidth = data_size / time_in_seconds / 1e9  # GB/s
    
    return bandwidth  # return the bandwidth result
end

# Array to hold the bandwidth results from each run
bandwidth_results = Float64[]

# Run the function 25 times and store the results
for i in 1:25
    push!(bandwidth_results, estimate_bandwidth())
end

# Calculate average and standard deviation of the results
average_bandwidth = mean(bandwidth_results)
std_dev_bandwidth = std(bandwidth_results)

println("Number of threads: ", Threads.nthreads())
println("Average Memory Bandwidth: $average_bandwidth GB/s")
println("Standard Deviation of Memory Bandwidth: $std_dev_bandwidth GB/s")