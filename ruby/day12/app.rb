#!/usr/bin/env ruby

require 'ostruct'

# day12 solution
input_file_path = File.expand_path("../../../inputs/day12", __FILE__)
instrs = File.readlines(input_file_path).map(&:strip)

Direction = Struct.new(:symbol, :x_mult, :y_mult)
class Direction
  ALL = {
    "N" => Direction.new("N", 0, +1),
    "E" => Direction.new("E", +1, 0),
    "S" => Direction.new("S", 0, -1),
    "W" => Direction.new("W", -1, 0),
  }

  def self.for(direction_s)
    ALL[direction_s]
  end

  ORDER_R = %w[E S W N]
  def turn(turn_direction, degrees)
    order = case turn_direction
            when "L"
              ORDER_R.reverse
            when "R"
              ORDER_R
            end
    turns = degrees / 90
    direction_s = (order * 2).drop_while{|x| x != self.symbol}.take(turns + 1).last
    Direction.for(direction_s)
  end

end

Ferry = Struct.new(:direction, :x, :y)
class Ferry

  def move(direction, distance)
    # curr = "(#{self.x},#{self.y})"
    direction = direction || self.direction
    self.x += distance * direction.x_mult
    self.y += distance * direction.y_mult

    # puts "#{curr} => (#{self.x},#{self.y})"
    self
  end

  def navigate(instrs)
    instrs.reduce(self) do |ferry, instr|
      case instr
      when /N|S|W|E/
        direction = Direction.for(instr[0])
        ferry.move(direction, instr[1..-1].to_i)
      when /L|R/
        ferry.direction = ferry.direction.turn(instr[0], instr[1..-1].to_i)
        ferry
      when /F/
        ferry.move(nil, instr[1..-1].to_i)
      end
    end
  end

  def manhattan_dist
    self.x.abs + self.y.abs
  end
end

ferry = Ferry.new(Direction.for("E"), 0, 0).navigate(instrs)
puts ferry.manhattan_dist

exit

ferry = Ferry.new(Direction.for("E"), 0, 0).navigate(<<~INSTRS.lines.map(&:strip))
F10
N3
F7
R90
F11
INSTRS
puts ferry.manhattan_dist
