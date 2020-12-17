#!/usr/bin/env ruby

# day17 solution
input_file_path = File.expand_path("../../../inputs/day17", __FILE__)

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

def cycle(hypercube)
  hypercube = expand(hypercube)

  hypercube.each_with_index.map do |grid, w|
    grid.each_with_index.map do |plane, z|
      plane.each_with_index.map do |row, y|
        row.each_with_index.map do |c, x|
          neighbor_active_count = neighbor_coords(x, y, z, w).count {|(x, y, z, w)| hypercube.dig(w, z, y, x) == '#'}

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
end

def neighbor_coords(x, y, z, w)
  plane = (x-1..x+1).to_a.product (y-1..y+1).to_a
  grid = (z-1..z+1).flat_map{|z| plane.map{|x, y| [x, y, z]}}
  (w-1..w+1).flat_map{|w| grid.map{|x, y, z| [x, y, z, w]}} - [[x, y, z, w]]
end

def part2(plane0_s)
  hypercube = [[plane0_s.lines.map{|x| x.strip.chars}]]

  6.times do
    hypercube = cycle hypercube
    puts "cycled"
  end

  puts hypercube.flatten.count{|x| x == '#'}
end

#part2(<<~EX)
#.#.
#..#
##
#EX

part2 File.read(input_file_path)
