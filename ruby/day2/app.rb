#!/usr/bin/env ruby

# Run as below:
# ruby app.rb < input

def parse(line)
  rule, password = line.split(":").map(&:strip)
  range, char = rule.split(' ')
  min, max = range.split('-').map(&:to_i)
  [min, max, char, password]
end

def valid_part2?(pos1, pos2, char, password)
  (password[pos1 - 1] == char) ^ (password[pos2 - 1] == char)
end

def valid_part1?(min, max, char, password)
  char_count = password.each_char.count {|x| x == char} 
  (min..max).include?(char_count)
end

def valid_password_count(lines, validator)
  lines.find_all {|line| validator.call(*parse(line)) }.count
end

lines = ARGF.each_line.to_a
puts "Part1: #{valid_password_count(lines, method(:valid_part1?))}"
puts "Part2: #{valid_password_count(lines, method(:valid_part2?))}"
