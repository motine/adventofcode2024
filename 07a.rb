input = <<~EOS
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
EOS

input = File.read("07.txt")

class Equation
  def self.parse(str)
    value, nums = str.split(":")
    new(value.to_i, nums.split(" ").map(&:to_i))
  end

  attr_reader :test_value, :numbers

  def initialize(test_value, numbers)
    @test_value = test_value
    @numbers = numbers
  end

  def possible?
    num, *rest = @numbers
    possible_step(num, rest)
  end

  def inspect = "Eq<#{@test_value}: #{@numbers.join(" ")}>"

  protected

  def possible_step(value_so_far, numbers_left)
    return false if value_so_far > @test_value # the operands will make the number only bigger, so we can stop right now (assumption there are no zeros in @numbers)
    return @test_value == value_so_far if numbers_left.empty?
    num, *rest = numbers_left

    possible_step(value_so_far + num, rest) || possible_step(value_so_far * num, rest)
  end
end

puts input
  .split("\n")
  .map { Equation.parse(_1) }
  .select { _1.possible? }
  .sum { _1.test_value }
