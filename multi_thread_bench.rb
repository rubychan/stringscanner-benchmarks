require 'benchmark'
require 'thread'

require 'helpers/simple_scanner'
require 'helpers/null_encoder'

$stdout.sync = true

# config with:
# 
#   ruby script.rb [input size in MB] [size of one data chunk in LOC]
class MultiThreadBench < Bench
  
  # EuRuKo 2011 defaults
  # DEFAULT_INPUT_SIZE_MB  = 160
  # DEFAULT_CHUNK_SIZE_LOC = 300_000
  
  # more modest defaults
  DEFAULT_INPUT_SIZE_MB  = 3
  DEFAULT_CHUNK_SIZE_LOC = 5_000
  
  def before
    @info = []
  end
  
  def after
    puts @info
  end
  
  def run
    threads = []
    seconds = Benchmark.realtime do
      do_multi threads
      threads.each(&:join).map { |t| t[:out] }.join
    end
    mb = input.size / 1_000_000.0
    @info << "Multi-Threaded: %0.1f MB in %0.2fs = %0.1f MB/s @ %d threads" % [mb, seconds, mb / seconds, threads.size]
    
    seconds = Benchmark.realtime do
      do_single
    end
    mb = input.size / 1_000_000.0
    @info << "Single-Threaded: %0.1f MB in %0.2fs = %0.1f MB/s" % [mb, seconds, mb / seconds]
  end
  
  def input
    @input ||=
      begin
        input_size = ((ARGV.join(' ')[/--input (\d+)/, 1] || DEFAULT_INPUT_SIZE_MB).to_f * 1_000_000).to_i
        SimpleScanner.generate_input input_size
      end
  end
  
  def chunk_size
    @chunk_size ||= (ARGV.join(' ')[/--chunks (\d+)/, 1] || DEFAULT_CHUNK_SIZE_LOC).to_i
  end
  
  def do_multi threads
    @block.call input, chunk_size do |chunk|
      threads << Thread.new do
        Thread.current[:out] = encode chunk
      end
    end
  end
  
  def do_single
    encode input
  end
  
  def encode input
    NullEncoder.new.encode SimpleScanner.new(input)
  end
end unless defined? MultiThreadBench
