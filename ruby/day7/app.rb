#!/usr/bin/env ruby

require 'ostruct'

# day7 solution
input_file_path = File.expand_path("../../../inputs/day7", __FILE__)
lines = File.readlines(input_file_path).map(&:strip)

# your solution
example =<<~EXAMPLE
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
EXAMPLE

def parse_content_bag(bag)
  count_s, color = bag.gsub(/ bag?s?./, "").split(" ", 2).map(&:strip)
  OpenStruct.new(count: count_s.to_i, color: color)
end

def parse_contents(contents)
  if "no other bags." == contents
    []
  else
    contents.split(",").map{|x| parse_content_bag(x)}
  end
end
def parse_line(rule)
  bag, contents = rule.split("contain").map(&:strip)
  OpenStruct.new(
    bag: bag.gsub("bags", "").strip,
    contents: parse_contents(contents)
  )
end

def inner_bags_for(rules_h, bag)
  return [] if rules_h[bag] == []
  rules_h[bag] + rules_h[bag].map{|b| inner_bags_for(rules_h, b)}
end

def digest_rules(rules_h)
  rules_h.map do |bag, _contents|
    [bag, inner_bags_for(rules_h, bag).flatten]
  end.to_h
end

def containers_for(bag, digest)
  digest.count{|_color, inner_bags| inner_bags.include?(bag)}
end

rule = parse_line("light red bags contain 1 bright white bag, 2 muted yellow bags.")
raise "incorrect parser #{rule}" unless rule.bag == "light red"
raise "incorrect parser #{rule}" unless rule.contents.map{|x| [x.count, x.color]} == [[1, "bright white"], [2, "muted yellow"]]
rule = parse_line("faded blue bags contain no other bags.")
raise "incorrect parser #{rule}" unless rule.bag == "faded blue"
raise "incorrect parser #{rule}" unless rule.contents == []

example =<<~EXAMPLE
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
EXAMPLE

rules = lines.map{|x| parse_line(x)}
rules_h = rules.map{|x| [x.bag, x.contents.map(&:color)]}.to_h
digest = digest_rules(rules_h) # => {"bright white" => ["dark orange", ...]}
# puts containers_for("shiny gold", digest)

## part 2

def inner_bags(bag, rules_h)
  return 0 if rules_h[bag] == []
  inner = rules_h[bag].map{|x| x.count * inner_bags(x.color, rules_h)}.sum
  return rules_h[bag].map(&:count).sum + inner
end

bag = "shiny gold"
rules_h = rules.map{|x| [x.bag, x.contents]}.to_h

puts "# part2"
puts inner_bags(bag, rules_h).inspect
