#!/usr/bin/env ruby

# day4 solution
input_file_path = File.expand_path("../../../inputs/day4", __FILE__)

# your solution
def parse_passport(raw_passport)
  raw_passport.gsub("\n", " ").split(" ").map{|x| x.strip.split(":")}.to_h
end

MANDATORY_FIELDS = %w[byr iyr eyr hgt hcl ecl pid]
VALID_HAIR_COLOR = /^#[0-9a-f]{6}$/
VALID_EYE_COLORS = %w[amb blu brn gry grn hzl oth]
VALID_PASSPORT = /^[0-9]{9}$/

def valid_number?(number_string, length, range)
  number_string.length == length && range.include?(number_string.to_i)
end

def valid_height?(height)
  case height
  when /cm/
    (150..193).include?(height.gsub("cm", "").to_i)
  when /in/
    (59..76).include?(height.gsub("in", "").to_i)
  else
    false
  end
end

def valid?(passport)
  MANDATORY_FIELDS.all?{|f| passport.key?(f)} &&
    valid_number?(passport["byr"], 4, 1920..2002) &&
    valid_number?(passport["iyr"], 4, 2010..2020) &&
    valid_number?(passport["eyr"], 4, 2020..2030) &&
    valid_height?(passport["hgt"]) &&
    VALID_HAIR_COLOR.match?(passport["hcl"]) &&
    VALID_EYE_COLORS.include?(passport["ecl"]) &&
    VALID_PASSPORT.match?(passport["pid"])
end

#puts valid?(parse_passport(<<~EOP))
#iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
#hcl:#cfa07d byr:1929 hgt:65in
#EOP

puts File.read(input_file_path)
  .split("\n\n")
  .map{|x| parse_passport(x)}
  .count{|x| valid?(x)}
