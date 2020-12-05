#!/usr/bin/env ruby

require 'ostruct'

# day5 solution
input_file_path = File.expand_path("../../../inputs/day5", __FILE__)
lines = File.readlines(input_file_path).map(&:strip)

# your solution
def row(code)
  code = code[0, 7]

  min = 0
  max = 127
  code.chars.each_with_index.each do |char, idx|
    case char
    when "F"
      max = (min + max) / 2
    when "B"
      min = 1 + (min + max) / 2
    end
    #puts [idx, char, ":", min, max].inspect
  end
  raise "Invalid code: #{code}, min: #{min} max: #{max}" if min != max
  min
end

def col(code)
  code = code[7, 3]

  min = 0
  max = 7
  code.chars.each_with_index.each do |char, idx|
    case char
    when "L"
      max = (min + max) / 2
    when "R"
      min = 1 + (min + max) / 2
    end
    #puts [idx, char, ":", min, max].inspect
  end
  raise "Invalid code: #{code}, min: #{min} max: #{max}" if min != max
  min
end

def seat_id(code)
  row(code) * 8 + col(code)
end

#puts seat_id("FBFBBFFRLR")

# part 1
# puts lines.map{|x| seat_id(x)}.max

# part 2
def find_gaps(seat_ids)
  gaps = []
  prev_sid = nil
  seat_ids.sort.each do |sid|
    if prev_sid && (sid - prev_sid) > 1
      gaps.push(OpenStruct.new(low: prev_sid, high: sid))
    end
    prev_sid = sid
  end
  gaps
end


def my_seat(lines)
  seat_ids = lines.map{|x| seat_id(x)}
  gaps = find_gaps(seat_ids)
  gap = gaps.find{|x| x.high - x.low == 2}
  gap.low + 1
end

puts my_seat(lines)
