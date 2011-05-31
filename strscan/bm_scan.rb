Bench.new do
  string = "string\n" * 10_000
  1000.times do
    scanner = StringScanner.new string
    scanner.scan(/\w+\n/) until scanner.eos?
  end
end