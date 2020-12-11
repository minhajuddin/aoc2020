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

def compute_path_count()

def solve(inputs)
  wall = 0
  inbuilt = inputs.max + 3
  inputs = (inputs << wall << inbuilt).sort

  startj = 0
  endj = 3
  path_count = 0
  loop do
    sub_inputs = inputs.find_all{|x| x >= startj && x <= endj}
    path_count = compute_path_count(sub_inputs, startj, endj)
  end
  end
end
