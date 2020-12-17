#!/usr/bin/env ruby

# day17 solution
input_file_path = File.expand_path("../../../inputs/day17", __FILE__)

def dbg(grid)
  grid.each_with_index do |plane, z|
    puts "z=#{z}------------"
    puts plane.map{|x| x.join()}.join("\n")
  end
  puts '--'
end

def zeroed(arr)
  return '.' unless arr.is_a?(Array)

  arr.map{|x| zeroed(x)}
end

def expand(arr)
  return arr unless arr.is_a?(Array)

  #inner_expanded = arr
  inner_expanded = arr.map{|x| expand(x)}

  padder = [zeroed(inner_expanded.first)]
  padder + inner_expanded + padder
end

def cycle(grid)
  grid = expand(grid)

  grid.each_with_index.map do |plane, z|
    #puts "P>>>>>>>"
    #puts plane.inspect
    #puts "P<<<<<<<<"

    plane.each_with_index.map do |row, y|
      #puts "R<<<<<<<<"
      #puts row.inspect
      #puts "R<<<<<<<<"
      row.each_with_index.map do |c, x|
        neighbor_active_count = neighbor_coords(x, y, z).count {|(x, y, z)| grid.dig(z, y, x) == '#'}

        #puts "#{x},#{y},#{z} => #{neighbor_active_count}"
        if c == '#' && [2, 3].include?(neighbor_active_count)
          '#'
        elsif c == '.' && neighbor_active_count == 3
          '#'
        else
          '.'
        end
      end
    end
  end
end

def neighbor_coords(x, y, z)
  plane = (x-1..x+1).to_a.product (y-1..y+1).to_a
  (z-1..z+1).flat_map{|z| plane.map{|x, y| [x, y, z]}} - [[x, y, z]]
end

def part1(plane0_s)
  grid = [plane0_s.lines.map{|x| x.strip.chars}]

  6.times do
    dbg grid
    grid = cycle grid
  end

  dbg grid

  puts grid.flatten.count{|x| x == '#'}
end

part1(<<~EX)
.#.
..#
###
EX

part1 File.read(input_file_path)
