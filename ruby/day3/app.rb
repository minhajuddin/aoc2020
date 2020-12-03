#!/usr/bin/env ruby

# day3 solution
input_file_path = File.expand_path("../../../inputs/day3", __FILE__)
lines = File.readlines(input_file_path).map(&:strip)

# your solution
tree_count = 0
x = 0
(0..(lines.length-1)).each do |y|
  line = lines[y]
  tree_count += 1 if line[x] == "#"
  #puts "#{y}\t#{x}\t#{line[x]}"
  x += 3
  x %= line.length
end

puts tree_count
