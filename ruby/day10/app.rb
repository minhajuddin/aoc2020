#!/usr/bin/env ruby

# day10 solution
input_file_path = File.expand_path("../../../inputs/day10", __FILE__)

# your solution
example =<<~EX.lines.map(&:strip).map(&:to_i)
1
4
5
6
7
10
11
12
15
16
19
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

# part 1
#inputs = layout_adapters(example)
#diffs = count_diff(inputs)

#puts diffs
#puts diffs[1] * diffs[3]

#inputs = layout_adapters(example2)
#diffs = count_diff(inputs)

#puts diffs
#puts diffs[1] * diffs[3]

#inputs = File.readlines(input_file_path).map{|x| x.strip.to_i}
#inputs = layout_adapters(inputs)
#diffs = count_diff(inputs)

#puts diffs
#puts diffs[1] * diffs[3]

def count_possibilities(inputs)
  inputs = layout_adapters(inputs)
  first = 0
  last = inputs.max

  curr = first
  counts = []

  #0-3: 0-1  => 1
  #1-4: 1-4  => 1
  #4-7: 4567 457 467 47 => 4
  #7-10: 7-10 => 1
  #10-13: 10 11 12, 10 12 => 2
  #12-15: 12-15 : 1
  #15:18: 15-16: 1
  #16:19: 16-19: 1
  #19:21: 19-21: 1

  possibilities = ->(inputs) do
    {
      4 => 4, # 4567, 4 inputs have 4 ways of being laid out: 4567, 457, 467, 47
      3 => 2, # 457, 3 inputs have 2 ways of being laid out: 457, 47
      2 => 1 # 47, 2 inputs have 1 way of being laid out: 47
    }[inputs.count]
  end

  loop do
    next3 = inputs.find_all{|x| x >= curr && x <= (curr + 3)}
    puts ">>>NEXT3: (#{curr}, #{next3.max}) #{next3.inspect}"
    counts.push possibilities.(next3)
    curr = next3.max

    break if curr == last
  end

  #puts counts.inspect
  counts.reduce(1, &:*)
end

def valid?(combo)
  puts "validating #{ combo.inspect }"
  !combo.sort.each_cons(2).any?{|a, b| (b - a) > 3}
end

def count_possibilities2(inputs)
  inputs = inputs.sort
  oj = 0 # outlet jolt
  iaj = inputs.max + 3 # input adapter jolt

  (1..inputs.length).map do |adapter_count|
    inputs.combination(adapter_count).count do |combo|
      valid?(combo << oj << iaj)
    end
  end.sum
end

# puts count_possibilities2(example)
#puts count_possibilities2(example2)
#puts count_possibilities(example2)


#def combinations(inputs, start_j, end_j)
  #cs = inputs.find_all{|x| (start_j..end_j).include?(x)}
  #puts cs.inspect
  #cs.count
#end

#cs = steps.each_cons(2).map do |a, b|
  #combinations(inputs, a, b)
#end

#puts cs.map{|x| x}.inspect

inputs = layout_adapters(example2)
diffs = count_diff(inputs)

puts diffs
puts diffs[1] * diffs[3]

