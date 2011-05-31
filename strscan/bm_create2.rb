def Bench.run
  10_000_000.times do |i|
    StringScanner.new i.to_s
  end
end