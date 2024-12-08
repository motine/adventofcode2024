input = <<~EOS
  47|53
  97|13
  97|61
  97|47
  75|29
  61|13
  75|53
  29|13
  97|29
  53|29
  61|53
  97|53
  61|29
  47|13
  75|47
  97|75
  47|61
  75|61
  47|29
  75|13
  53|13

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  75,97,47,61,53
  61,13,29
  97,13,75,29,47
EOS

input = File.read("05.txt")

rules_str, updates_str = input.split("\n\n")
class Rule
  attr_reader :a, :b
  def initialize(str)
    @a, @b = str.split("|").map(&:to_i)
  end

  def inspect = "Rule<#{@a}|#{@b}>"
end

# page numbers
class Update
  attr_reader :pages
  def initialize(str)
    @pages = str.split(",").map(&:to_i)
  end

  def conforms_to_rule?(rule)
    index_of_a = pages.index(rule.a)
    index_of_b = pages.index(rule.b)
    return true if index_of_a.nil? || index_of_b.nil?
    index_of_a < index_of_b
  end

  def conforms_to_rules?(rules)
    rules.all? { conforms_to_rule?(_1) }
  end

  def middle_number = @pages[@pages.size / 2]

  def inspect = "Update<#{@pages.join(", ")}>"
end

rules = rules_str.split("\n").map { Rule.new(_1) }
updates = updates_str.strip.split("\n").map { Update.new(_1) }

puts updates
  .select { _1.conforms_to_rules?(rules) }
  .map(&:middle_number)
  .sum
