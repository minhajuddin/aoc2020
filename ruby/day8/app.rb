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
    [1, 0, :nop]
  when /acc/
    [1, instr.gsub('acc ', '').to_i, :acc]
  when /jmp/
    [instr.gsub('jmp ', '').to_i, 0, :jmp]
  end
end

def corrupt_line?(ptr, ptr_delta, op_code, instr_count)
  case op_code
  when :acc
    false
  when :nop
    ptr + ptr_delta == instr_count - 1
  when :jmp
    ptr + 1 == instr_count - 1
  end
end

def fix_op_code(op_code, ptr_delta)
  case op_code
  when "nop"
    "jmp #{ptr_delta}"
  when "jmp"
    "nop #{ptr_delta}"
  else
    raise "Shouldn't happen"
  end
end

def exec_game_console_code(instruction_map)
  # puts instruction_map.map{|k, v| "#{k}:\t#{v}"}.join("\n")
  # puts "--------------------"
  visited_lines = Set.new

  ptr = 0
  acc = 0
  loop do
    instr = instruction_map[ptr]
    # puts "execing L#{ptr}:\t #{instr}"

    if visited_lines.member?(ptr)
      puts "Infinite Loop #{ptr}: #{instr}" 
      return :infinite_loop
    end

    # puts instruction_map
    if !instr
      puts "L:#{ptr} #{instr} ENDING-NORMALLY" 
      return acc
    end
    ptr_delta, acc_delta, op_code = exec_instr(instr)

    visited_lines.add(ptr)

    ptr += ptr_delta
    acc += acc_delta
  end

  return acc
end

def brute_force_fix(instructions)
  instruction_map = instructions.each_with_index.map{|k, v| [v, k]}.to_h

  # puts instruction_map.map{|k, v| "#{k}:\t#{v}"}.join("\n")
  # puts "--------------------"

  instruction_map.each do |ptr, instr|
    op_code, arg = instr.split(" ").map(&:strip)

    next if op_code == "acc"

    acc = exec_game_console_code(instruction_map.merge(ptr => fix_op_code(op_code, arg)))
    if acc != :infinite_loop
      puts "FOUND CORRUPTION AT: L#{ptr} #{instr}"
      return acc
    end
  end
end

# puts brute_force_fix(example.lines.map(&:strip)).inspect
puts brute_force_fix(lines).inspect
