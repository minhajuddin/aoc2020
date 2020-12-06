#!/usr/bin/env ruby

# day6 solution
input_file_path = File.expand_path("../../../inputs/day6", __FILE__)

# your solution
def any_yes(group)
  group.gsub(/[^a-z]/, "").chars.uniq.count
end

# your solution
def all_yes(group)
  all_yes_answers = group.lines.map{|x| x.strip.chars}.reduce(('a'..'z').to_a) do |x, acc|
    x & acc
  end
  all_yes_answers.count
end


groups = File.read(input_file_path).split("\n\n")
# puts groups.map{|x| any_yes(x)}.sum
puts groups.map{|x| all_yes(x)}.sum
