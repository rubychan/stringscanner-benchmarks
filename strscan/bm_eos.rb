Bench.new do
  scanner = StringScanner.new ''
  50_000_000.times do
    scanner.eos?
  end
end