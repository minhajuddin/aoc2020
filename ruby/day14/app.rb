#!/usr/bin/env ruby

# day14 solution
input_file_path = File.expand_path("../../../inputs/day14", __FILE__)
lines = File.readlines(input_file_path).map(&:strip)

# your solution

#puts mask_number(11, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X')
#puts mask_number(101, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X')
#puts mask_number(0, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X')


BITSIZE = 36
# SOLVE = :part1
SOLVE = :part2
State = Struct.new(:mem, :mask)
class State
  MEM_RX = /^mem\[(?<addr>\d+)\]\s*=\s*(?<num>\d+)$/

  def exec(instr)
    case instr
    when /mask/
      self.mask = instr.split('=').last.strip
    when /mem/
      m = MEM_RX.match(instr)
      addr, num = [m[:addr].to_i, m[:num].to_i]
      send(SOLVE, addr, num)
    end

    self
  end

  def part1(addr, num)
    self.mem[addr] = mask_number(num, self.mask)
  end

  def part2(addr, num)
    get_addresses(addr, self.mask).each do |addr|
      self.mem[addr] = num
    end
  end

  def expand(prefixes, chars)
    return prefixes if chars == []

    c = chars.shift

    if c == "1"  || c == "0"
      return expand(prefixes.map{|x| x + c}, chars)
    elsif c == "X"
      return expand( prefixes.map{|x| x + "0"} + prefixes.map{|x| x + "1"} , chars)
    end
  end

  def get_addresses(addr, mask)
    addr = addr.to_s(2).rjust(BITSIZE, "0")
    addresses = expand([""], mask.chars.zip(addr.chars).map do |m, a|
      case m
      when "0"
        a
      else
        m
      end
    end)

    addresses.map{|x| x.to_i(2)}
  end

  def mask_number(n, mask)
    (n | mask.tr('X', '0').to_i(2)) & (mask.tr('X', '1').to_i(2))
  end
end

# puts 43.to_s(2).rjust(BITSIZE)
# puts "000000000000000000000000000000X1001X"
# puts "--"
# puts State.new(nil, nil).get_addresses(43, "000000000000000000000000000000X1001X").join("\n")

state = lines.reduce(State.new(Hash.new(0), nil)) do |state, instr|
  state.exec(instr)
end

puts state.mem.values.sum
