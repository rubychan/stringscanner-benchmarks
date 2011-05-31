require 'strscan/multi_thread_benchmark'

class << MultiThreadBenchmark.new('multi-slice')
  def each_chunk
    chunk_offsets = [0]
    
    input.lines.each_slice chunk_size do |lines|
      chunk_offsets << chunk_offsets.last + lines.join.bytesize
    end
    
    chunk_offsets.each_cons(2) do |this_chunk, next_chunk|
      yield input[this_chunk...next_chunk]
    end
  end
end