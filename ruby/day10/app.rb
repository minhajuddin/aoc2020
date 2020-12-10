#!/usr/bin/env ruby

# day10 solution
input_file_path = File.expand_path("../../../inputs/day10", __FILE__)

# your solution
example =<<~EX.lines.map(&:strip).map(&:to_i)
16
10
15
5
1
11
7
19
6
12
4
EX

example2 =<<~EX.lines.map(&:strip).map(&:to_i)
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
EX

def layout_adapters(inputs)
  max_joltage = inputs.max
  inputs
    .push(max_joltage + 3) # built in adapter
    .push(0) # charging outlet
    .sort
end

def count_diff(inputs)
  inputs.each_cons(2).reduce(Hash.new(0)) do |acc, (a, b)|
    acc[b - a] += 1
    acc
  end
end

inputs = layout_adapters(example)
diffs = count_diff(inputs)

puts diffs
puts diffs[1] * diffs[3]

inputs = layout_adapters(example2)
diffs = count_diff(inputs)

puts diffs
puts diffs[1] * diffs[3]

inputs = File.readlines(input_file_path).map{|x| x.strip.to_i}
inputs = layout_adapters(inputs)
diffs = count_diff(inputs)

puts diffs
puts diffs[1] * diffs[3]
