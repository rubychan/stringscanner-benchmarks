require 'multi_thread_bench'

MultiThreadBench.new do |input, chunk_size, &encode|
  input.lines.each_slice chunk_size do |lines|
    encode[lines.join]
  end
end
