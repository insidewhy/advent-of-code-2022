#!/usr/bin/env crystal

struct Point
  getter x : Int32
  getter y : Int32

  def initialize(@x : Int32, @y : Int32)
  end

  def move(direction : Char) : Point
    case direction
    when 'U'
      return Point.new(@x, @y + 1)
    when 'D'
      return Point.new(@x, @y - 1)
    when 'R'
      return Point.new(@x + 1, @y)
    when 'L'
      return Point.new(@x - 1, @y)
    else
      raise Exception.new("Bad direction #{direction}")
    end
  end

  # return a point moved in the direction of y_delta
  private def move_up(y_delta : Int32) : Point
    return Point.new(@x, @y + (y_delta > 0 ? 1 : -1))
  end

  # return a point moved in the direction of x_delta
  private def move_right(x_delta : Int32) : Point
    return Point.new(@x + (x_delta > 0 ? 1 : -1), @y)
  end

  # return a point moved one step diagonally in the direction (x_delta, y_delta)
  private def move_diagonally(x_delta : Int32, y_delta : Int32) : Point
    return Point.new(
      @x + (x_delta > 0 ? 1 : -1),
      @y + (y_delta > 0 ? 1 : -1)
    )
  end

  def follow(ahead : Point) : Point?
    x_delta = ahead.x - @x
    y_delta = ahead.y - @y

    case x_delta.abs
    when 0
      if y_delta.abs == 2
        return move_up y_delta
      end
    when 1
      if y_delta.abs == 2
        return move_diagonally x_delta, y_delta
      end
    when 2
      if y_delta.abs == 0
        return move_right x_delta
      else
        return move_diagonally x_delta, y_delta
      end
    else
      raise Exception.new("Impossible x delta #{x_delta}")
    end

    return nil
  end
end

LENGTH = 10
PENULTIMATE_IDX = LENGTH - 1
rope = LENGTH.times.map { |_| Point.new(0, 0) }.to_a
visited = Set { rope.last }

File.each_line("input-9.txt") do |line|
  direction = line[0]
  amount = line[2..].to_i
  amount.times do
    rope[0] = rope.first.move direction
    (1..PENULTIMATE_IDX).each do |i|
      next_point = rope[i].follow rope[i - 1]
      if next_point.nil?
        # if this point didn't move then the next segments will not either
        break
      end

      rope[i] = next_point
      if i == PENULTIMATE_IDX
        visited.add next_point
      end
    end
  end
end

puts visited.size
