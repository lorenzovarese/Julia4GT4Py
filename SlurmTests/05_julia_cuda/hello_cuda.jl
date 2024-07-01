using CUDA

    function hello_world()
       @cuprintf("Greetings from block %ld, thread %ld!\n", Int64(blockIdx().x), Int64(threadIdx().x))
       return
   end

@cuda blocks=2 threads=2 hello_world()
synchronize()