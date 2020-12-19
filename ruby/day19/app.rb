#!/usr/bin/env ruby

# day19 solution
input_file_path = File.expand_path("../../../inputs/day19", __FILE__)
lines = File.readlines(input_file_path).map(&:strip)

ex = <<~EX
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
EX

Rule = Struct.new(:idx)

CharRule = Struct.new(:idx, :char)
class CharRule
  def match?(message)
  end
end

module Rules
  module_function

  def parse(rules_text)
    rules_text.lines.map do |rule_line|
      idx_s, rule_s = rule_line.split(":")
    end
  end

  def parse_one(rule_s)
    rules = rule_s.split("|").map do |rule_s_part|
      case rule_s_part
      when /^"[a-z]"$/
        rule_s_part.tr('"', "")
      when /[\d\s]*/
        rule_s_part.split(" ").map{|x| x.to_i}
      end
    end
    Rules.or(rules)
  end

  def char(char)
    ->(message){ [message[0] == char, message[1..]] }
  end

  def or(*rules)
    ->(message){ rules.any?{|rule| rule.call(message).first } }
  end

  def ord(*rules)
    ->(message) do
      rest_msg, match = rules.reduce([message, true]) do |(msg, match), rule|
        rule_match, rest_msg = rule.call(msg)
        [rest_msg, rule_match && match]
      end

      (rest_msg == "") && match
    end
  end

  def idx(idx)
    ->(message, rules_h) { rules_h[idx].call(message) }
  end

  def dbg(rule)
    ->(message) do
      res = rule.call(message)
      puts "checking rule with message '#{message}': match? '#{res}'"
      res
    end
  end

end


#puts Rules.dbg(Rules.or(Rules.dbg(Rules.char("a")), Rules.dbg(Rules.char("b")))).call("ba").inspect
#puts Rules.or(Rules.char("a"), Rules.char("b")).call("abc")
#puts Rules.idx(0).call("a", 0 => Rules.dbg(Rules.char("e")), 1 => Rules.char("b"))
puts Rules.parse("49 14|13 11")
exit

# your solution
def parse_rules(rules)
  rules.map do |rule|
  end
end

def part1(input)
  rules, messages = input.split("\n\n").map{|x| x.lines.map(&:strip)}
  rules = parse_rules(rules)
end
part1(ex)
