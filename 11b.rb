input = "0 1 10 99 999"
input = "125 17"
input = File.read("11.txt")

# --- recursive
# def blink_count(value, iteration, max_iteration)
#   return 1 if iteration == max_iteration
#   if value == 0 # set to 1
#     blink_count(1, iteration + 1, max_iteration)
#   elsif value.to_s.size.even? # split
#     digits = value.to_s
#     middle_index = digits.size / 2
#     left, right = digits[0...middle_index], digits[middle_index..]
#     blink_count(left.to_i, iteration + 1, max_iteration) + blink_count(right.to_i, iteration + 1, max_iteration)
#   else # multiply by 2024
#     blink_count(value * 2024, iteration + 1, max_iteration)
#   end
# end

# ITERATIONS = 75

# stone_values = input.split(" ").map { _1.to_i }
# puts stone_values.sum { blink_count(_1, 0, ITERATIONS) }
# blink_count(125, 0, 6)


# --- counting the results
# wow this was a very smart idea. unfortunately, i did not have it my self.
# i googled around a bit and found someone proposing this approach in a sentence.
# i took it from there.

def create_default_hash = Hash.new { |h, k| h[k] = 0 }

stones = input.split(" ").each_with_object(create_default_hash ) { |str, acc| acc[str.to_i] += 1 }

75.times do
  new_stones = create_default_hash
  stones.each do |value, count|
    middle_index, remainder = value.to_s.size.divmod(2)

    if value == 0 # set to 1
      new_stones[1] += count
    elsif remainder == 0 # even number of digits, we split
      digits = value.to_s
      left, right = digits[0...middle_index], digits[middle_index..]
      new_stones[left.to_i] += count
      new_stones[right.to_i] += count
    else # multiply by 2024
      new_stones[value * 2024] += count
    end
    stones = new_stones
  end
end

# puts stones
puts stones.values.sum
