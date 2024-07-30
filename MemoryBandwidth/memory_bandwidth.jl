using BenchmarkTools, Statistics, LinearAlgebra
using Polyester: @batch
using Base.Threads: @threads

function benchmark_addition_broadcast(a, b)
    data_size = sizeof(a) + sizeof(b)
    bench = @benchmarkable $a .+= $b
    results = run(bench)
    time_in_seconds = median(results.times) / 1e9
    bandwidth = data_size / time_in_seconds / 1e9
    return bandwidth
end

function benchmark_addition_multithreads(a, b, c, each_index_c)
    data_size = sizeof(a) + sizeof(b) + sizeof(c)
    bench = @benchmarkable (@threads for i in $each_index_c
                                @inbounds $c[i] = $a[i] + $b[i]
                            end)
    results = run(bench)
    time_in_seconds = median(results.times) / 1e9
    bandwidth = data_size / time_in_seconds / 1e9
    return bandwidth
end

function benchmark_addition_polyester(a, b, c, each_index_c)
    data_size = sizeof(a) + sizeof(b) + sizeof(c)
    bench = @benchmarkable (@batch for i in $each_index_c
                                @inbounds $c[i] = $a[i] + $b[i]
                            end)
    results = run(bench)
    time_in_seconds = median(results.times) / 1e9
    bandwidth = data_size / time_in_seconds / 1e9
    return bandwidth
end

function benchmark_addition_blas(a, b)
    data_size = sizeof(a) + sizeof(b)
    bench = @benchmarkable BLAS.axpy!(1.0, $a, $b)
    results = run(bench)
    time_in_seconds = median(results.times) / 1e9
    bandwidth = data_size / time_in_seconds / 1e9
    return bandwidth
end

function estimate_bandwidth()
    a = rand(Float64, 10000000)
    b = rand(Float64, 10000000)
    c = similar(a)
    eic = eachindex(c)

    bandwidth_broadcast = benchmark_addition_broadcast(a, b)
    bandwidth_multithreads = benchmark_addition_multithreads(a, b, c, eic)
    bandwidth_polyester = benchmark_addition_polyester(a, b, c, eic)
    bandwidth_blas = benchmark_addition_blas(a, b)

    return (bandwidth_broadcast, bandwidth_multithreads, bandwidth_polyester, bandwidth_blas) 
end

function main()
    bandwidth_results_broadcast = Float64[]
    bandwidth_results_threads = Float64[]
    bandwidth_results_polyester = Float64[]
    bandwidth_results_blas = Float64[]

    println("Benchmark started!")
    for i in 1:10
        println("Running benchmark ", i)
        bandwidth_broadcast, bandwidth_threads, bandwidth_polyester, bandwidth_blas = estimate_bandwidth()
        push!(bandwidth_results_broadcast, bandwidth_broadcast)
        push!(bandwidth_results_threads, bandwidth_threads)
        push!(bandwidth_results_polyester, bandwidth_polyester)
        push!(bandwidth_results_blas, bandwidth_blas)
    end

    println("Number of threads specified in the current environment: ", Threads.nthreads())
    println("Memory Bandwidth Broadcast -> \tMedian: $(round(median(bandwidth_results_broadcast), digits=5)) GB/s, Average: $(round(mean(bandwidth_results_broadcast), digits=5)), Std Dev: $(round(std(bandwidth_results_broadcast), digits=5)) GB/s")
    println("Memory Bandwidth Threads -> \tMedian: $(round(median(bandwidth_results_threads), digits=5)) GB/s, Average: $(round(mean(bandwidth_results_threads), digits=5)), Std Dev: $(round(std(bandwidth_results_threads), digits=5)) GB/s")
    println("Memory Bandwidth Polyester -> \tMedian: $(round(median(bandwidth_results_polyester), digits=5)) GB/s, Average: $(round(mean(bandwidth_results_polyester), digits=5)), Std Dev: $(round(std(bandwidth_results_polyester), digits=5)) GB/s")
    println("Memory Bandwidth BLAS -> \tMedian: $(round(median(bandwidth_results_blas), digits=5)) GB/s, Average: $(round(mean(bandwidth_results_blas), digits=5)), Std Dev: $(round(std(bandwidth_results_blas), digits=5)) GB/s")
end

main()
