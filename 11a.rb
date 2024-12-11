input = "0 1 10 99 999"
input = "125 17"
input = File.read("11.txt")

Stone = Data.define(:value) do
  def digit_count
    @dc ||= (Math.log10(value) + 1).to_i
  end

  def zero? = value == 0

  def even_digits? = digit_count.even?

  def split
    middle_index = digit_count / 2
    digits = value.to_s
    left, right = digits[0...middle_index], digits[middle_index..]
    [Stone.new(left.to_i), Stone.new(right.to_i)]
  end
end

class Corridor
  attr_reader :stones

  def self.parse(str)
    new(str.split(" ").map { Stone.new(_1.to_i) })
  end

  def initialize(stones)
    @stones = stones
  end

  def blink!
    @stones = @stones.flat_map do |stone|
      next Stone.new(1) if stone.zero?
      next stone.split if stone.even_digits?
      next Stone.new(stone.value * 2024)
    end
  end
end

corridor = Corridor.parse(input)
25.times { corridor.blink! }
puts corridor.stones.count
