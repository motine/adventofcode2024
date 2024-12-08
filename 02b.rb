class Report
  def self.parse(str)
    new(str.split(" ").map(&:to_i))
  end

  def initialize(levels)
    @levels = levels
    @differences = @levels.zip(@levels.drop(1)).map { _2 ? _2 - _1 : nil }.compact
  end

  def variations
    [self] + @levels.size.times.map { |i| Report.new(@levels.dup.tap { _1.delete_at(i) }) }
  end

  def monotone? = @differences.all?(&:positive?) || @differences.all?(&:negative?)

  def smooth? = @differences.map(&:abs).max <= 3

  def safe? = monotone? && smooth?

  def to_s = @levels.to_s
end

reports = File.readlines("02.txt").map { Report.parse(_1) }
sum = reports.count do |report|
  report.variations.any?(&:safe?)
end
puts sum