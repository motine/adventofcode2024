require "debug"
input = "2333133121414131402"
input = File.read("09.txt")
# exit

disk_map = input.chars.map(&:to_i)

class Block
  attr_reader :id, :size
  attr_accessor :space_after

  def initialize(id, size, space_after)
    @id = id
    @size = size
    @space_after = space_after || 0
  end

  def to_s
    [@id] * @size + ["."] * @space_after
  end

  # this can be optimized
  def checksum(start_position)
    result = 0
    size.times do |i|
      result += (start_position + i) * id
    end
    result
  end
end

# build disk image
blocks = disk_map.each_slice(2).with_index.map do |(fill_count, empty_count), i|
  Block.new(i, fill_count, empty_count)
end

# puts blocks.map(&:to_s).join

# compact
blocks.last.id.downto(0) do |block_id_to_move|
  i_to_move = blocks.rindex { _1.id == block_id_to_move }
  block_to_move = blocks[i_to_move]

  insert_index = blocks.index { _1.space_after >= block_to_move.size }
  # binding.debugger if block_id_to_move == 5433
  next unless insert_index
  next if insert_index >= i_to_move

  block_before_moved = blocks[i_to_move - 1]
  block_before_insert = blocks[insert_index]

  # calculate space_after for touched blocks
  bspace = block_to_move.space_after
  block_to_move.space_after = block_before_insert.space_after - block_to_move.size
  block_before_insert.space_after = 0
  block_before_moved.space_after += block_to_move.size + bspace

  # change the block array
  blocks.delete_at(i_to_move)
  blocks.insert(insert_index + 1, block_to_move)
end

puts blocks.map(&:to_s).join

# checksum
checksum = 0
pos = 0
blocks.each do |block|
  checksum += block.checksum(pos)
  pos += block.size + block.space_after
end
puts checksum

# mmm, this is odd. I have the right answer for the test case given in the text, but I do not have the right final result.
# apparently my solution is too high.
