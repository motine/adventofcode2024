require "debug"

input = <<~EOS
  0123
  1234
  8765
  9876
EOS
input = <<~EOS
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
EOS
input = File.read("10.txt")

class Map
  def self.parse(str)
    new(str.split("\n").map { |line| line.chars.map { |c| c.to_i } })
  end

  def initialize(matrix)
    @matrix = matrix
  end

  def [](coordinate)
    return nil if coordinate.x < 0 || coordinate.x >= @matrix[0].size || coordinate.y < 0 || coordinate.y >= @matrix.size
    @matrix[coordinate.y][coordinate.x]
  end

  # yields the coordinate & the height
  def each(&block)
    @matrix.each_with_index do |row, y|
      row.each_with_index do |h, x|
        yield Coordinate.new(x, y), h
      end
    end
  end
end

map = Map.parse(input)

Coordinate = Data.define(:x, :y) do
  def +(other)
    self.class.new(x + other.x, y + other.y)
  end

  def to_s = "Coordinate<#{x}, #{y}>"
end

# find start points
heads = [] # TODO use Enumerator::new
map.each do |coordinate, h|
  heads << coordinate if h == 0
end

DIRECTIONS = [
  Coordinate.new(1, 0),
  Coordinate.new(0, 1),
  Coordinate.new(0, -1),
  Coordinate.new(-1, 0)
]

def walk(map, coordinate, last_height)
  # binding.debugger
  height = map[coordinate]
  return [] if height.nil? # out of bounds
  return [] unless height - last_height == 1 # wrong incline
  return [coordinate] if map[coordinate] == 9

  DIRECTIONS.flat_map do |dir|
    walk(map, coordinate + dir, height)
  end
end

# find a path
total_a, total_b = 0, 0
heads.each do |start|
  reachables = walk(map, start, -1)
  total_a += reachables.uniq.size
  total_b += reachables.size
end

puts total_a, total_b