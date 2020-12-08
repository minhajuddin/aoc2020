#!/usr/bin/env ruby

require 'set'

# day8 solution
input_file_path = File.expand_path("../../../inputs/day8", __FILE__)
lines = File.readlines(input_file_path).map(&:strip)

# your solution
example =<<~EX
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
EX

def exec_instr(instr)
  case instr
  when /nop/
    [1, 0]
  when /acc/
    [1, instr.gsub('acc ', '').to_i]
  when /jmp/
    [instr.gsub('jmp ', '').to_i, 0]
  end
end

def exec_game_console_code(instructions)
  instruction_map = instructions.each_with_index.map{|k, v| [v, k]}.to_h
  visited_lines = Set.new

  ptr = 0
  acc = 0
  loop do
    instr = instruction_map[ptr]
    puts "execing L#{ptr}:\t #{instr}"

    break if !instr || visited_lines.member?(ptr)
    ptr_delta, acc_delta = exec_instr(instr)
    visited_lines.add(ptr)

    ptr += ptr_delta
    acc += acc_delta
  end

  puts "ACC: #{acc}"
end

#exec_game_console_code(example.lines.map(&:strip))
exec_game_console_code(lines)
