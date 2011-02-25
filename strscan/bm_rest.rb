def Bench.run
  scanner = StringScanner.new 'test string'
  20_000_000.times do
    scanner.rest
  end
end