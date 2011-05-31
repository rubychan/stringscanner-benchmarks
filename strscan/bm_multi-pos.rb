require 'strscan/multi_thread_benchmark'
require 'strscan/simple_scanner_with_range'

class << MultiThreadBenchmark.new('multi-pos')
  def each_chunk
    chunk_offsets = [0]
    
    input.lines.each_slice chunk_size do |lines|
      chunk_offsets << chunk_offsets.last + lines.join.bytesize
    end
    
    chunk_offsets.each_cons(2) do |this_chunk, next_chunk|
      yield [input, this_chunk...next_chunk]
    end
  end
  
  def encode input
    input = [input] unless input.is_a? Array
    NullEncoder.new.encode SimpleScannerWithRange.new(*input)
  end
end
