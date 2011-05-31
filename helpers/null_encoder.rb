# an encoder that does nothing
class NullEncoder
  def setup
    @out = ''
  end
  
  def finish
    @out
  end
  
  def encode scanner
    setup
    scanner.tokenize self
    finish
  end
  
  def text_token text, kind
  end
  
  def begin_group kind
  end
  
  def end_group kind
  end
end
