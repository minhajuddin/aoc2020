#!/usr/bin/env ruby

# day15 solution
input_file_path = File.expand_path("../../../inputs/day15", __FILE__)
lines = File.readlines(input_file_path).map(&:strip)

Occ = Struct.new(:number, :count, :positions)

class Occ
  def self.update(occ, num, pos)
      occ ||= Occ.new(num, 0, [])
      occ.count += 1
      occ.positions.unshift(pos)
      occ
  end
end

# your solution
def next_num(series, n)
  series = series.split(",").map{|x| x.strip.to_i}

  mem = {}
  prev = nil
  (1..n).each do |i|

    ## use the starting numbers
    starting_num = series[i - 1]
    if starting_num
      mem[starting_num] = Occ.new(starting_num, 1, [i])
      prev = mem[starting_num]
      next
    end

    ## else look at the previous number

    ## first time seeing the prev number
    if prev.count == 1
      prev = mem[0] = Occ.update(mem[0], 0, i)
      next
    end

    ## we've seen the prev number before
    num = prev.positions[0] - prev.positions[1]
    prev = mem[num] = Occ.update(mem[num], num, i)
    next


  end
  # puts "---"
  # puts mem
  # puts "---"
  ans, _ = mem.find{|_, x| x.positions[0] == n}
  ans
end

#puts next_num("0,3,6", 10)
puts next_num(lines.first, 2020)
puts next_num(lines.first, 30000000)
