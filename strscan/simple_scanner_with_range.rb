require 'strscan'

# a simple scanner with 9 rules and an optional range options
class SimpleScannerWithRange < StringScanner
  def initialize code, range = 0...code.bytesize
    super code
    @start = range.begin
    @stop  = range.end
  end
  
  def tokenize encoder
    self.pos = @start
    scan_tokens encoder
    encoder
  end
  
  def scan_tokens encoder
    until eos?
      if matched = scan(/ +/)
        encoder.text_token matched, :space
      elsif matched = scan(/\n/)
        if pos >= @stop
          puts "stopped @ #{pos}" if $VERBOSE
          return
        end
        encoder.text_token matched, :space
      elsif matched = scan(/!/)
        encoder.text_token matched, :not_going_to_happen
      elsif matched = scan(/=/)  #/
        encoder.text_token matched, :not_going_to_happen
      elsif matched = scan(/%/)
        encoder.text_token matched, :not_going_to_happen
      elsif matched = scan(/\d+/)
        encoder.text_token matched, :number
      elsif matched = scan(/\w+/)
        encoder.text_token matched, :word
      elsif matched = scan(/[,.]/)
        encoder.text_token matched, :op
      elsif scan(/\(/)
        encoder.begin_group :par
      elsif scan(/\)/)
        encoder.end_group :par
      else
        getch
      end
    end
  end
end
