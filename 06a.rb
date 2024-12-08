require "debug"
input = <<~EOS
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
EOS

input = File.read("06.txt")

map = input.split("\n")
x_range = 0..(map[0].size - 1)
y_range = 0..(map.size - 1)

# extract start position & remove start marker
start_y = map.index { _1.include?("^") }
start_x = map[start_y].index("^")
map[start_y][start_x] = "."

def rotate_direction(dir)
  return [1, 0] if dir == [0, -1]
  return [0, 1] if dir == [1, 0]
  return [-1, 0] if dir == [0, 1]
  return [0, -1] if dir == [-1, 0]
  raise "bad direction"
end

# move the guard
pos_x, pos_y = start_x, start_y
direction = [0, -1]
while x_range.cover?(pos_x) && y_range.cover?(pos_y)
  map[pos_y][pos_x] = "X"

  if x_range.cover?(pos_x + direction[0]) && y_range.cover?(pos_y + direction[1]) && map[pos_y + direction[1]][pos_x + direction[0]] == "#"
    direction = rotate_direction(direction)
  end
  pos_x += direction[0]
  pos_y += direction[1]
end

# count the X
puts map.sum { |row| row.count("X") }
