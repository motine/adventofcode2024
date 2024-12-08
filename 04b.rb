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
    @values = input.split("\n")
  end

  def at(v)
    @values[v.y][v.x] if (0..x_size-1).cover?(v.x) && (0..y_size-1).cover?(v.y)
  end

  def x_size = @values[0].size

  def y_size = @values.size

  # start is a Vector, pattern another Grid
  def interposes?(start, pattern)
    pattern.y_size.times do |y|
      pattern.x_size.times do |x|
        v = Vector.new(x,y)
        pattern_char = pattern.at(v)
        return false unless pattern_char == " " || at(start + v) == pattern_char
      end
    end
    true
  end
end

grid = Grid.new(input)

PATTERNS = <<EOS
M M
 A 
S S
---
M S
 A 
M S
---
S M
 A 
S M
---
S S
 A 
M M
EOS

PATTERN_GRIDS = PATTERNS.split("---").map { Grid.new(_1.strip) }

count = 0
grid.y_size.times do |y|
  grid.x_size.times do |x|
    PATTERN_GRIDS.each do |pattern|
      start = Vector.new(x, y)
      count += 1 if grid.interposes?(start, pattern)
    end
  end
end

puts count
