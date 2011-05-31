def Bench.run
  string = "string\n"
  scanner = StringScanner.new string
  regexp = /(?!)/
  20_000_000.times do
    scanner.scan(regexp)
  end
end