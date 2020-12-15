#!/usr/bin/env ruby


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

module Turner
  module_function

  def parse(direction)
    m = (/^(?<direction>L|R)(?<degrees>\d+)$/).match(direction)
    [m['direction'], m['degrees'].to_i]
  end

  def turn(direction, x, y)
    direction, degrees = parse(direction)

    if direction == "L"
      degrees = 360 - degrees
    end
    turn_right(degrees, x, y)
  end

  def turn_right(degrees, x, y)
    return [x, y] if degrees == 0

    turn_right(degrees - 90, y, -1 * x)
  end
end

Waypoint = Struct.new(:x_units, :y_units)
class Waypoint
  def update(instr)
    case instr
    when /N|S|E|W/
      direction = Direction.for(instr[0])
      self.x_units += direction.x_mult * instr[1..-1].to_i
      self.y_units += direction.y_mult * instr[1..-1].to_i
    when /L|R/
      self.x_units, self.y_units = Turner.turn(instr, self.x_units, self.y_units)
    end
  end
end

Ferry = Struct.new(:waypoint, :x, :y)
class Ferry

  def move(times)
    # curr = "(#{self.x},#{self.y})"
    self.x += times * waypoint.x_units
    self.y += times * waypoint.y_units

    # puts "#{curr} => (#{self.x},#{self.y})"
  end

  def navigate(instrs)
    instrs.reduce(self) do |ferry, instr|
      case instr
      when /F/
        ferry.move(instr[1..-1].to_i)
      else
        ferry.waypoint.update(instr)
      end

      ferry
    end
  end

  def manhattan_dist
    self.x.abs + self.y.abs
  end
end

ferry = Ferry.new(Waypoint.new(10, 1), 0, 0).navigate(instrs)
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
