#!/usr/bin/env ruby

require 'ostruct'

# day13 solution
input_file_path = File.expand_path("../../../inputs/day13", __FILE__)


def part1(input_file_path)
  start_ts, bids = File.readlines(input_file_path).map(&:strip)

  start_ts = start_ts.to_i
  bids = bids.split(',').reject{|x| x == 'x'}.map{|x| x.strip.to_i}

  wait_times = bids.map do |bid|
    time_after_bus_departs = start_ts % bid
    wait_time = if time_after_bus_departs == 0
                  0
                else
                  bid - time_after_bus_departs
                end
    [wait_time, bid]
  end.to_h

  min_wait_time = wait_times.keys.min
  bid = wait_times[min_wait_time]
  puts bid * min_wait_time
end

Bus = Struct.new(:id, :offset)
class Bus
  def valid_offset?(t)
    (id == "x") || ((t + offset) % id == 0)
  end

  def dbg(t)
    [id, offset, ((id == "x") || (t % id))].join(":")
  end
end

def part2(bids, start_ts)
  buses = bids.split(",").each_with_index.map{|x, i| Bus.new(x.to_i == 0 ? x : x.to_i , i)}

  max_bus = buses.max_by{|x| x.id.to_i}

  t = start_ts - ((start_ts + max_bus.offset) % max_bus.id)
  #puts [t, max_bus]
  #exit

  loop do
     #puts "#{t}=>#{buses.map{|b| b.dbg(t)}.join("|")}"
    return t if buses.all?{|b| b.valid_offset?(t)}
    t += max_bus.id
  end
end

_, bids = File.readlines(input_file_path).map(&:strip)
puts part2(bids, 0)
#puts part2(bids, 100000000000000)
puts part2("17,x,13,19", 2)
#puts part2("7,13,x,x,59,x,31,19", 2)
#puts part2('1789,37,47,1889', 2)
17 * 
