#!/usr/bin/env ruby

# day16 solution
input_file_path = File.expand_path("../../../inputs/day16", __FILE__)
data = File.read(input_file_path)

# your solution
validations_block, your_ticket_block, nearby_tickets_block = data.split("\n\n")

valid_ranges = validations_block.strip.scan(%r<\d+-\d+>).map do |x|
  a, b = x.split("-").map(&:to_i)
  (a..b)
end

nearby_tickets = nearby_tickets_block.scan(%r<\d+>).map(&:to_i)
invalid_tickets = nearby_tickets.find_all do |tid|
  !valid_ranges.any? { |r| r.include?(tid)}
end

puts invalid_tickets.sum
