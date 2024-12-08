# instructions = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
instructions = File.read("03.txt")
operands = []

matcher = Regexp.union(/(mul)\((\d{1,3}),(\d{1,3})\)/, /(do)\(\)/, /(don)\'t\(\)/)

enabled = true
instructions.scan(matcher) do |match|
  match = $~
  groups = match.to_a
  _, meth, *params = groups.compact
  case meth.to_sym
  when :mul
    operands << [match[2].to_i, match[3].to_i] if enabled
  when :do
    enabled = true
  when :don
    enabled = false
  end
end
puts operands.sum { _1 * _2 }
