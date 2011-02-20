def Bench.run
  string = ''
  5_000_000.times do
    StringScanner.new string
    string << '.'
  end
end