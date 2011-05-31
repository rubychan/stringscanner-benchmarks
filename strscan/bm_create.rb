def Bench.run
  string = ''
  10_000_000.times do
    StringScanner.new string
    string << '.'
  end
end