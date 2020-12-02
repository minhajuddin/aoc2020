
def parse_rule(rule)
  range, char = rule.split(' ')
  min, max = range.split('-').map(&:to_i)
  [min..max, char]
end

def valid?(line)
  rule, password = line.split(":").map(&:strip)
  range, char = parse_rule(rule)
  char_count = password.each_char.count {|x| x == char} 
  range.include?(char_count)
end

puts ARGF.each_line.find_all{|x| valid?(x)}.count
