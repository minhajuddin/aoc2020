#!/usr/bin/env ruby

# day18 solution
input_file_path = File.expand_path("../../../inputs/day18", __FILE__)
lines = File.readlines(input_file_path).map(&:strip)

# your solution

def parse(line)
  line.chars.reduce([[], str_acc]) do |(ast, str_acc), c|
  end
end

puts (parse "2 * 9")
#parse "2 * 9 + 5 + ((8 + 6 + 5) * (2 + 3 * 9 + 3) + 5) * (7 + 9 + 7 + 3 * 7) * 5"
