#!/usr/bin/env ruby

# day9 solution
input_file_path = File.expand_path("../../../inputs/day9", __FILE__)

# your solution
nums = File.readlines(input_file_path).map(&:strip).map(&:to_i)
nums = <<~EX.lines.map(&:strip).map(&:to_i)
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
EX

preamble_count = 5

i = preamble_count
loop do
  nums[i]
  if !nums[i-preamble_count, preamble_count].combination(2).any?{|xs| xs.sum == nums[i]}
    puts "L#{i}: #{nums[i]} IS THE GRINCH"
    exit
  end
  i += 1
end
