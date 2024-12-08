input = <<~EOS
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
EOS

input = File.read("04.txt")

class Vector
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def *(other) = self.class.new(@x * other, @y * other)

  def +(other) = self.class.new(@x + other.x, @y + other.y)

  def inspect = "V{#{@x}, #{y}}"
end

class Grid
  def initialize(input)
    @values = input.split
  end

  def at(v)
    @values[v.y][v.x] if (0..x_size-1).cover?(v.x) && (0..y_size-1).cover?(v.y)
  end

  def x_size = @values[0].size

  def y_size = @values.size

  # start & direction are vectors
  def fits(start, direction, str = "XMAS")
    str.chars.each_with_index do |c, i|
      return false unless at(start + direction * i) == str[i]
    end
    true
  end
end

grid = Grid.new(input)

DIRECTIONS = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]
DIRECTION_VECTORS = DIRECTIONS.map { Vector.new(_1, _2) }

count = 0
grid.y_size.times do |y|
  grid.x_size.times do |x|
    DIRECTION_VECTORS.each do |direction|
      start = Vector.new(x, y)
      count += 1 if grid.fits(start, direction)
    end
  end
end

puts count
