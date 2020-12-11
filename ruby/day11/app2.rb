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

def occupied?(grid, row, col)
  return '.' if row.nil? || col.nil?
  return '.' if row < 0 || col < 0

  grid.dig(row, col) || '.'
end

def seat_in_direction(grid, row_i, col_i, dy, dx, row_l, col_l)

  loop do
    row_i += dy
    col_i += dx

    return '.' if row_i < 0 || col_i < 0 || row_i >= row_l || col_i >= col_l

    seat = grid.dig(row_i, col_i)
    return seat if seat == '#' || seat == 'L'
  end
end

def compute_seat_state(grid, seat, row_i, col_i)
  return '.' if seat == '.'

  row_l = grid.length
  col_l = grid.first.length

  #puts "#{seat}: #{row_i}x#{col_i} #{row_l}x#{col_l}"

  adjacent_occupied_seats = [
    n = seat_in_direction(grid, row_i, col_i, -1, 0, row_l, col_l),
    s = seat_in_direction(grid, row_i, col_i, +1, 0, row_l, col_l),
    e = seat_in_direction(grid, row_i, col_i, 0, +1, row_l, col_l),
    e = seat_in_direction(grid, row_i, col_i, 0, -1, row_l, col_l),
    nw = seat_in_direction(grid, row_i, col_i, -1, -1, row_l, col_l),
    ne = seat_in_direction(grid, row_i, col_i, -1, +1, row_l, col_l),
    sw = seat_in_direction(grid, row_i, col_i, +1, -1, row_l, col_l),
    se = seat_in_direction(grid, row_i, col_i, +1, +1, row_l, col_l),
  ].count{|x| x == '#'}

  if adjacent_occupied_seats == 0
    '#'
  elsif seat == '#' and adjacent_occupied_seats >= 5
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
  system("clear")
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

#grid = parse_grid(example)
grid = parse_grid(input_grid)
puts find_stable_grid(grid)
