require 'strscan'

# a simple scanner with 9 rules
class SimpleScanner < StringScanner
  INPUT_SEED = "2011 alpha, beta, (gamma), delta.\n"
  
  def self.generate_input input_size
    input = INPUT_SEED * (input_size.to_f / INPUT_SEED.size).ceil
    input.slice! input_size..-1
    input
  end
  
  def tokenize encoder
    scan_tokens encoder
    encoder
  end
  
  def scan_tokens encoder
    until eos?
      if matched = scan(/\s+/)
        encoder.text_token matched, :space
      elsif matched = scan(/!/)
        encoder.text_token matched, :not_going_to_happen
      elsif matched = scan(%r/=/)
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
