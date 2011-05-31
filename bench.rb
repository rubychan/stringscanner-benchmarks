class Bench
  def self.new(*)
    @@last_instance = super
  end
  
  def self.last_instance
    @@last_instance
  end
  
  def initialize &block
    @block = block
  end
  
  def before
    # define additional information to be printed before the benchmark here
  end
  
  def run
    # define benchmark here
    @block.call
  end
  
  def after
    # define additional information to be printed after the benchmark here
  end
end
