def Bench.run
  scanner = StringScanner.new 'test string'
  50_000_000.times do
    scanner.rest_size
  end
end