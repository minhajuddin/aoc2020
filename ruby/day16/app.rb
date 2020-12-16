#!/usr/bin/env ruby

# day16 solution
input_file_path = File.expand_path("../../../inputs/day16", __FILE__)
data = File.read(input_file_path)

# your solution
validations_block, your_ticket_block, nearby_tickets_block = data.split("\n\n")

def part1(validations_block, nearby_tickets_block)
  valid_ranges = validations_block.strip.scan(%r<\d+-\d+>).map do |x|
    a, b = x.split("-").map(&:to_i)
    (a..b)
  end

  nearby_tickets = nearby_tickets_block.scan(%r<\d+>).map(&:to_i)
  invalid_tickets = nearby_tickets.find_all do |tid|
    !valid_ranges.any? { |r| r.include?(tid)}
  end

  puts invalid_tickets.sum
end


def invalid_ticket_nums(validations_block, nearby_tickets_block)
  valid_ranges = validations_block.strip.scan(%r<\d+-\d+>).map do |x|
    a, b = x.split("-").map(&:to_i)
    (a..b)
  end

  nearby_tickets = nearby_tickets_block.scan(%r<\d+>).map(&:to_i)
  invalid_tickets = nearby_tickets.find_all do |tid|
    !valid_ranges.any? { |r| r.include?(tid)}
  end

  invalid_tickets
end

def resolve(mappings)
  mappings
    .sort_by{|k, v| v.length}
    .reduce([{}, []]) do |(memo, resolved_cols), (idx, cols)|
      col = (cols - resolved_cols).first
      memo[col] = idx
      [memo, resolved_cols + [col]]
    end.first
end

def part2(validations_block, your_ticket_block, nearby_tickets_block)
  valid_ranges = validations_block.strip.lines.map do |l|
    field, ranges_s = l.split(":").map(&:strip)
    ranges = ranges_s.scan(%r<\d+-\d+>).map do |x|
      a, b = x.split("-").map(&:to_i)
      (a..b)
    end
    [field, ranges]
  end.to_h

  # skip the first line
  invalid_ticket_nums = invalid_ticket_nums(validations_block, nearby_tickets_block)
  tickets = your_ticket_block + "\n" + nearby_tickets_block
  tickets = tickets.lines.reject{|x| !x.include?(",")}.map{|x| x.split(",").map{|n| n.strip.to_i}}
                         .reject{|t| (t & invalid_ticket_nums).any?}

  field_values = tickets.first.length.times.map{|i| tickets.map{|t| t[i]}}

  #puts field_values.inspect

  potential_mappings = field_values.each_with_index.map do |col, i|
    #if i == 0
      #puts ">>>>>>>>>>>>>>>>>>>>>"
      #puts col.sort.inspect
      #puts ">>>>>>>>>>>>>>>>>>>>>"
    #end
    fields = valid_ranges.map do |field, ranges|
      #puts "#{field}: #{ranges.inspect}"
      match = col.all?{|c| ranges.any?{|r| r.include?(c)}}
      #puts "field: #{field}, col: #{i}: #{match}" if match

      field if match
    end.compact

    [i, fields]
  end.to_h


  field_mappings = resolve(potential_mappings)
  your_ticket_fields = your_ticket_block.split("\n").find{|x| x.include?(",")}.split(",").map{|x| x.strip.to_i}

  field_mappings.find_all{|m, _| m.start_with?("departure")}.map {|_, i| your_ticket_fields[i]}.reduce(&:*)
end

puts part2(validations_block, your_ticket_block, nearby_tickets_block)
exit
puts part2(*<<~EX.split("\n\n"))
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
EX
