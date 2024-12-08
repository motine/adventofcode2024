input = <<~EOS
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
EOS

input = File.read("08.txt")

def draw_map(map, anti_positions)
  output_map = map.map { _1.dup }
  anti_positions.each { |x, y| output_map[y][x] = "#" } # we overwrite existing letters
  output_map.each { |row| puts row.join }
end

# letters = input.chars.uniq - [".", "\n"]
map = input.split("\n").map { _1.chars }

# determine letter positions
letter_positions = Hash.new { |hash, key| hash[key] = [] }
map.each_with_index do |row, y|
  row.each_with_index do |letter, x|
    letter_positions[letter] << [x, y] if letter != "."
  end
end

# collect all anti_positions
anti_positions = []
letter_positions.each do |_letter, positions|
  positions.permutation(2).each do |(x1, y1), (x2, y2)| # go through all combinations
    dx, dy = x2 - x1, y2 - y1
    anti_positions << [x2 + dx, y2 + dy]
  end
end

anti_positions.uniq!
anti_positions.reject! { |x, y| x < 0 || y < 0 || x >= map[0].size || y >= map.size }

draw_map(map, anti_positions)
puts anti_positions.size
