# instructions = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
instructions = File.read("03.txt")
operands = []
instructions.scan(/mul\((\d{1,3}),(\d{1,3})\)/) do |match|
  match = $~
  operands << [match[1].to_i, match[2].to_i]
end
puts operands.sum { _1 * _2 }