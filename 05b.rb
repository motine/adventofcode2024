require 'debug'

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
class RuleGraph
  def self.parse(str)
    new.tap do |result|
      str.split("\n").each do |line|
        from, to = line.split("|").map(&:to_i)
        result.add!(from, to)
      end
    end
  end

  def initialize
    @connections = Hash.new { |hash, key| hash[key] = [] }
  end

  def add!(from, to)
    @connections[from] << to
  end

  # returns only the rules that apply to the given pages
  def slice(pages)
    RuleGraph.new.tap do |result|
      @connections.each do |from, tos|
        next unless pages.include?(from)
        tos.each do |to|
          result.add!(from, to) if pages.include?(to)
        end
      end
    end
  end

  def valid?(pages)
    pages.each_cons(2) do |from, to|
      return false unless @connections[from].include?(to)
    end
    true
  end

  # Kahn's algorithm see https://en.wikipedia.org/wiki/Topological_sorting#Kahn's_algorithm
  def topological_sort
    result = []
    graph = connections_clone
    pages_with_incoming = graph.values.flatten.uniq
    pages_without_incoming = graph.keys - pages_with_incoming
    while pages_without_incoming.any?
      n = pages_without_incoming.pop
      result << n
      next if graph[n].nil?
      graph[n].dup.each do |m|
        graph[n].delete(m)
        pages_without_incoming << m unless graph.values.flatten.include?(m) # incoming to m
      end
    end
    result
  end

  def inspect = @connections.inspect

  protected
  def connections_clone
    @connections.to_h { |k,v| [k,v.dup] }
  end
end

# page numbers
class Update
  attr_reader :pages

  def self.parse(str)
    new(str.split(",").map(&:to_i))
  end

  def initialize(pages)
    @pages = pages
  end

  def middle_number = @pages[@pages.size / 2]

  def inspect = "Update<#{@pages.join(", ")}>"
end

rules = RuleGraph.parse(rules_str)
updates = updates_str.strip.split("\n").map { Update.parse(_1) }

sum = 0
updates.each do |update|
  next if rules.valid?(update.pages)
  sub_rules = rules.slice(update.pages)
  pages = sub_rules.topological_sort
  sum += Update.new(pages).middle_number
end
puts sum
