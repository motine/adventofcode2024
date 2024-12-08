class Report
  def initialize(str)
    @levels = str.split(" ").map(&:to_i)
    @differences = @levels.zip(@levels.drop(1)).map { _2 ? _2 - _1 : nil }.compact
  end

  def monotone?
    @differences.all?(&:positive?) || @differences.all?(&:negative?)
  end

  def smooth?
    @differences.map(&:abs).max <= 3
  end

  def to_s
    @levels.to_s
  end
end

reports = File.readlines("02.txt").map { Report.new(_1) }
puts reports.count { _1.monotone? && _1.smooth? }
