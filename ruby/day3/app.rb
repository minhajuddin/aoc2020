#!/usr/bin/env ruby

# day3 solution
input_file_path = File.expand_path("../../../inputs/day3", __FILE__)
$lines = File.readlines(input_file_path).map(&:strip)

# your solution
def tree_count(dx, dy)
  tree_count = 0
  x = 0
  y = 0

  loop do
    line = $lines[y]
    return tree_count unless line

    tree_count += 1 if line[x] == "#"

    #puts "#{y}\t#{x}\t#{line[x]}"
    x += dx
    x %= line.length
    y += dy
  end
end

puts tree_count(1, 1) * tree_count(3, 1) * tree_count(5, 1) * tree_count(7, 1) * tree_count(1, 2)
