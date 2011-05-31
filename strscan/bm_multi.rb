require 'strscan/multi_thread_benchmark'

class << MultiThreadBenchmark.new('multi')
  def each_chunk
    input.lines.each_slice chunk_size do |lines|
      yield lines.join
    end
  end
end
