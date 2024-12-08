require "debug"
require "progress_bar" # gem install progress_bar

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

map = input.split("\n").map { _1.chars }

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

def debug_print_map(map, start_x, start_y, added_obstacle_x, added_obstacle_y, pos_x = nil, pos_y = nil, direction = nil)
  new_map = map.map { _1.dup }
  new_map[added_obstacle_y][added_obstacle_x] = "O"
  new_map[start_y][start_x] = "^"
  new_map[pos_y][pos_x] = direction[0] != 0 ? "-" : "|" if pos_x
  puts "\n----\n\n"
  puts "#{added_obstacle_x}, #{added_obstacle_y}"
  puts new_map.map { _1.join }
end

def loops?(obstacle_map, start_x, start_y, added_obstacle_x, added_obstacle_y) # we pass the ranges for performance
  visit_map = Array.new(obstacle_map.size) { Array.new(obstacle_map[0].size) { [] } } # map of directions
  pos_x, pos_y = start_x, start_y
  direction = [0, -1]
  loop do
    # debug_print_map(obstacle_map, start_x, start_y, added_obstacle_x, added_obstacle_y) if visit_map[pos_y][pos_x].include?(direction)
    return true if visit_map[pos_y][pos_x].include?(direction) # the guard was here before and walked the same direction
    visit_map[pos_y][pos_x] << direction

    loop do # rotate by 90º as long as the next position would be an obstacle
      next_pos_x, next_pos_y = pos_x + direction[0], pos_y + direction[1]
      return false if next_pos_x < 0 || next_pos_y < 0 || next_pos_x >= obstacle_map[0].size || next_pos_y >= obstacle_map.size # we will be outside the map
      if (next_pos_x == added_obstacle_x && next_pos_y == added_obstacle_y) || obstacle_map.dig(next_pos_y, next_pos_x) == "#"
        direction = rotate_direction(direction)
        next
      end
      pos_x, pos_y = next_pos_x, next_pos_y
      break
    end
  end
end

bar = ProgressBar.new(map.size * map[0].size)

sum = 0
map.size.times do |y|
  map[0].size.times do |x|
    next if x == start_x && y == start_y
    next if map[y][x] == "#" # we know that the input is loop free
    sum += 1 if loops?(map, start_x, start_y, x, y)
    bar.increment!
  end
end

puts sum
