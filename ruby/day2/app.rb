#!/usr/bin/env ruby

# Run as below:
# ruby app.rb < input

def parse(line)
  rule, password = line.split(":").map(&:strip)
  range, char = rule.split(' ')
  min, max = range.split('-').map(&:to_i)
  [min, max, char, password]
end

def valid_part2?(line)
  pos1, pos2, char, password = parse(line)
  (password[pos1 - 1] == char) ^ (password[pos2 - 1] == char)
end

def valid_part1?(line)
  min, max, char, password = parse(line)
  char_count = password.each_char.count {|x| x == char} 
  (min..max).include?(char_count)
end

def valid_password_count(lines, validator)
  lines.find_all{|x| validator.call(x)}.count
end

lines = ARGF.each_line.to_a
puts "Part1: #{valid_password_count(lines, method(:valid_part1?))}"
puts "Part2: #{valid_password_count(lines, method(:valid_part2?))}"
