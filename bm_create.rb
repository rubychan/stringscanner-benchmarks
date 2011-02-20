def Bench.run
  string = ''
  1_000_000.times do
    StringScanner.new string
    string << '.'
  end
end