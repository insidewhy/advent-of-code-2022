#!/usr/bin/env crystal

struct Point
  getter x : Int32
  getter y : Int32

  def initialize(@x : Int32, @y : Int32)
  end

  def move!(direction : Char)
    case direction
    when 'U'
      @y += 1
    when 'D'
      @y -= 1
    when 'R'
      @x += 1
    when 'L'
      @x -= 1
    else
      raise Exception.new("Bad direction #{direction}")
    end
  end

  # pass a value more than or less than 0 and return a point moved 1 unit vertically in that direction
  private def move_up(y_delta : Int32) : Point
    return Point.new(@x, @y + (y_delta > 0 ? 1 : -1))
  end

  # pass a value more than or less than 0 and return a point moved 1 unit vertically in that direction
  private def move_right(x_delta : Int32) : Point
    return Point.new(@x + (x_delta > 0 ? 1 : -1), @y)
  end

  # combination of move_up and move_right
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
      case y_delta.abs
      when 0
        return move_right x_delta
      when 1
        return move_diagonally x_delta, y_delta
      end
    else
      raise Exception.new("Impossible x delta #{x_delta}")
    end

    return nil
  end
end

tail = Point.new(0, 0)
head = Point.new(0, 0)
visited = Set { tail }

File.each_line("input-9.txt") do |line|
  direction = line[0]
  amount = line[2..].to_i
  amount.times do
    head.move! direction
    next_tail = tail.follow head
    if next_tail
      tail = next_tail
      visited.add tail
    end
  end
end

puts visited.size
