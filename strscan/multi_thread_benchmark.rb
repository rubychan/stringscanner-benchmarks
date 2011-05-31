require 'benchmark'
require 'thread'

require 'strscan/simple_scanner'
require 'strscan/null_encoder'

$stdout.sync = true

# config with:
# 
#   ruby script.rb [input size in MB] [size of one data chunk in LOC]
class MultiThreadBenchmark < Struct.new :name, :input, :chunk_size
  
  # EuRuKo 2011 defaults
  DEFAULT_INPUT_SIZE_MB  = 160
  DEFAULT_CHUNK_SIZE_LOC = 300_000
  
  INPUT_SEED = "2011 alpha, beta, (gamma), delta.\n"
  
  ALL_TIMES    = 1
  SINGLE_TIMES = 2
  MULTI_TIMES  = 2
  
  class << self
    attr_reader :last_instance
    def new(*)
      @last_instance = super
      
      if defined? ::Bench
        def (::Bench).run
          MultiThreadBenchmark.last_instance.run
        end
      end
      
      @last_instance
    end
  end
  
  def initialize name
    super
  end
  
  def generate_input
    input_size = ((ARGV[0] || DEFAULT_INPUT_SIZE_MB).to_f * 1_000_000).to_i
    input = INPUT_SEED * (input_size.to_f / INPUT_SEED.size).ceil
    input.slice! input_size..-1
    input
  end
  
  def input
    @input ||= generate_input
  end
  
  def chunk_size
    @chunk_size ||= (ARGV[1] || DEFAULT_CHUNK_SIZE_LOC).to_i
  end
  
  def run
    print '...'
    puts
    
    ALL_TIMES.times do
      MULTI_TIMES.times do
        threads = []
        seconds = Benchmark.realtime do
          do_multi threads
          
          threads.each(&:join)
          
          threads.map { |t| t[:out] }.join
        end
        
        mb = input.size / 1_000_000.0
        puts 'Multi-Threaded: %0.1f MB in %0.2fs = %0.1f MB/s @ %d threads' % [mb, seconds, mb / seconds, threads.size]
      end
      
      SINGLE_TIMES.times do
        seconds = Benchmark.realtime do
          do_single
        end
        
        mb = input.size / 1_000_000.0
        puts 'Single-Threaded: %0.1f MB in %0.2fs = %0.1f MB/s' % [mb, seconds, mb / seconds]
      end
    end
  end
  
  def do_multi threads
    each_chunk do |chunk|
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
end unless defined? MultiThreadBenchmark
