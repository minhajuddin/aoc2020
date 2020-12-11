#!/usr/bin/env ruby

# day11 solution
input_file_path = File.expand_path("../../../inputs/day11", __FILE__)
input_grid = File.read(input_file_path)

# your solution
example = <<~EX
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
EX


def parse_grid(text)
  text.lines.map{|x| x.strip.chars}.reject{|x| x.empty?}
end

def seat_at(grid, row, col)
  if row < 0 || col < 0
    '.'
  else
    grid.dig(row, col) || '.'
  end
end

def compute_seat_state(grid, seat, row_i, col_i)
  return '.' if seat == '.'

  top_row = ((col_i - 1)..(col_i + 1)).map{|col| seat_at(grid, row_i - 1, col)}
  middle_row = [(col_i - 1),(col_i + 1)].map{|col| seat_at(grid, row_i, col)}
  bottom_row = ((col_i - 1)..(col_i + 1)).map{|col| seat_at(grid, row_i + 1, col)}
  adjacent_occupied_seats =  (top_row + middle_row + bottom_row).count{|x| x == '#'}

  if adjacent_occupied_seats == 0
    '#'
  elsif seat == '#' and adjacent_occupied_seats >= 4
    'L'
  else
    seat
  end
end

def recompute_grid(grid)
  grid.each_with_index.map do |row, row_i|
    row.each_with_index.map do |seat, col_i|
      compute_seat_state(grid, seat, row_i, col_i)
    end
  end
end

def print_grid(grid)
  puts '-' * grid.first.length
  puts grid.map{|r| r.join('')}.join("\n")
end

def find_stable_grid(grid)
  print_grid grid
  prev_grid = nil

  loop do
    grid = recompute_grid(grid)
    print_grid grid
    break if grid == prev_grid
    prev_grid = grid
  end
  grid.sum{|row| row.count{|x| x == '#'}}
end

grid = parse_grid(input_grid)
puts find_stable_grid(grid)
