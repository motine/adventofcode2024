input = "2333133121414131402"
input = File.read("09.txt")

disk_map = input.chars.map(&:to_i)

# build disk image
disk = []
disk_map.each_slice(2).with_index.each do |(fill_count, empty_count), i|
  empty_count ||= 0 # at the end we may not have a number for empties
  disk += [i] * fill_count
  disk += [nil] * empty_count
end

# compact
first_free = disk.index(nil)
i = disk.size
while first_free < i # go from right to left
  i -= 1
  next if !disk[i] # empty, so we move on

  disk[first_free] = disk[i]
  disk[i] = nil
  first_free += 1 while disk[first_free]
end

# checksum
checksum = disk.each_with_index.sum { |id, i| id ? i * id : 0 }
puts disk.join
puts checksum
