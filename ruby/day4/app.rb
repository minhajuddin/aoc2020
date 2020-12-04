#!/usr/bin/env ruby

# day4 solution
input_file_path = File.expand_path("../../../inputs/day4", __FILE__)

# your solution
def parse_passport(raw_passport)
  raw_passport.gsub("\n", " ").split(" ").map{|x| x.strip.split(":")}.to_h
end

MANDATORY_FIELDS = %w[byr iyr eyr hgt hcl ecl pid]
def valid?(passport)
  MANDATORY_FIELDS.all?{|f| passport.key?(f)}
end

puts File.read(input_file_path)
  .split("\n\n")
  .map{|x| parse_passport(x)}
  .count{|x| valid?(x)}
