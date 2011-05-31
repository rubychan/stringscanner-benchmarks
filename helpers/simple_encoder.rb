# an encoder for the CodeRay debug format
class SimpleEncoder
  def setup
    @out = ''
    @opened = []
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
    @out <<
      if kind == :space
        text
      else
        text.gsub!(/[)\\]/, '\\\\\0')  # escape ) and \
        "#{kind}(#{text})"
      end
  end
  
  def begin_group kind
    @opened << kind
    @out << "#{kind}<"
  end
  
  def end_group kind
    @opened.pop
    @out << '>'
  end
end
