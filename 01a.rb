lines = File.readlines("01.txt").map { _1.split("   ") }
left = lines.map { _1[0].to_i }
right = lines.map { _1[1].to_i }

pairs = left.sort.zip(right.sort)
distances = pairs.map { |a, b| (a - b).abs }
distances.sum