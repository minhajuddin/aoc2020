#!/usr/bin/env ruby

# day9 solution
input_file_path = File.expand_path("../../../inputs/day9", __FILE__)

# your solution
nums = <<~EX.lines.map(&:strip).map(&:to_i)
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
EX
nums = File.readlines(input_file_path).map(&:strip).map(&:to_i)

## part 1
def part1(nums)
  preamble_count = 5

  i = preamble_count
  loop do
    nums[i]
    if !nums[i-preamble_count, preamble_count].combination(2).any?{|xs| xs.sum == nums[i]}
      puts "L#{i}: #{nums[i]} IS THE GRINCH"
      exit
    end
    i += 1
  end
end

def find_cns(nums, grinch, idx)
  puts "L#{idx}: #{grinch}"
  # puts "FINDCNS: #{nums.inspect}, #{grinch}, #{idx}"
  (2..(nums.length - idx)).each do |i|
    sum = nums[idx, i].sum
    if  sum == grinch
      return [:found, nums[idx, i]]
    elsif sum > grinch
      return :not_found
    end
  end
end

## part 2
def part2(nums)
  preamble_count = 25

  i = preamble_count
  loop do
    nums[i]
    if !nums[i-preamble_count, preamble_count].combination(2).any?{|xs| xs.sum == nums[i]}
      puts "L#{i}: #{nums[i]} IS THE GRINCH"
      break
    end
    i += 1
  end

  grinch = nums[i]
  (0..(nums.length-1)).each do |i|
    status, found_nums = find_cns(nums, grinch, i)
    if status == :found
      found_nums = found_nums.sort
      puts "GRINCH: #{grinch}: SUM: #{found_nums.sum}: MIN+MAX:#{found_nums[0] + found_nums[-1]}"
      return
    end
  end
end

part2(nums)
