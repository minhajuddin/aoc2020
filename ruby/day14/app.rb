#!/usr/bin/env ruby

# day14 solution
input_file_path = File.expand_path("../../../inputs/day14", __FILE__)
lines = File.readlines(input_file_path).map(&:strip)

# your solution

#puts mask_number(11, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X')
#puts mask_number(101, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X')
#puts mask_number(0, 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X')


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
      self.mem[addr] = mask_number(num, self.mask)
    end

    self
  end

  def mask_number(n, mask)
    (n | mask.tr('X', '0').to_i(2)) & (mask.tr('X', '1').to_i(2))
  end
end

state = lines.reduce(State.new(Hash.new(0), nil)) do |state, instr|
  state.exec(instr)
end

puts state.mem.values.sum
