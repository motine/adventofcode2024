require "debug"

input = <<~EOS
  AAAA
  BBCD
  BBCC
  EEEC
EOS

input = File.read("12.txt")

# we represent empty plots as nil
Map = Data.define(:plots) do
  def self.parse(input)
    new(input.split("\n").map { _1.chars })
  end

  # def at(x, y)
  #   return nil if x < 0 || x >= hsize || y < 0 || y >= vsize
  #   plots[y][x]
  # end

  def hsize = plots[0].size

  def vsize = plots.size

  # def empty? = !any?

  # def any? = plots.any? { |row| row.any? { !_1.nil? } }

  def to_s = plots.map { _1.join }.join("\n")

  def inspect = to_s

  # retrieve the [x, y] coordinates for any occupied plot
  def any_occupied_coordinates
    plots.each_with_index do |row, y|
      row.each_with_index do |plant, x|
        next if plant.nil?
        return [x, y]
      end
    end
    nil
  end

  def cluster_at(x, y)
    cplots = Array.new(vsize) { Array.new(hsize, nil) }

    add_to_cluster(cplots, plots[y][x], x, y)
    Map.new(cplots)
  end

  # removes all plots from this map where other_map has a plant
  def remove_plots(other_map)
    rplots = plots.each_with_index.map do |row, y|
      row.each_with_index.map do |plant, x|
        other_map.plots[y][x] ? nil : plant
      end
    end
    self.class.new(rplots)
  end

  # the number of non-nil plots
  def area
    plots.sum do |row|
      row.sum do |plant|
        plant ? 1 : 0
      end
    end
  end

  def perimeter
    vsize.times.sum do |y|
      hsize.times.sum do |x|
        next 0 if plots[y][x].nil?
        sum = 0
        sum += 1 if y == 0 || plots[y - 1][x].nil? # top
        sum += 1 if y == vsize - 1 || plots[y + 1][x].nil? # bottom
        sum += 1 if x == 0 || plots[y][x - 1].nil? # left
        sum += 1 if x == hsize - 1 || plots[y][x + 1].nil? # right
        sum
      end
    end
  end

  protected

  def add_to_cluster(cplots, plant, x, y)
    return if x < 0 || x >= hsize || y < 0 || y >= vsize # out of bounds
    return if cplots[y][x] # we have been here before
    return if plots[y][x].nil? || plant != plots[y][x] # other plant

    cplots[y][x] = plant

    add_to_cluster(cplots, plant, x + 1, y)
    add_to_cluster(cplots, plant, x - 1, y)
    add_to_cluster(cplots, plant, x, y + 1)
    add_to_cluster(cplots, plant, x, y - 1)
  end
end

map = Map.parse(input)
clusters = [] # a cluster is a map of a single plant type

# we remove one cluster at the time from plots
map_with_removed_clusters = map # this is not a copy, but this is ok, because we will overwrite it in a second anyway
while (x, y = map_with_removed_clusters.any_occupied_coordinates)
  cluster = map_with_removed_clusters.cluster_at(x, y)
  map_with_removed_clusters = map_with_removed_clusters.remove_plots(cluster)
  clusters << cluster
end

puts clusters.sum { _1.area * _1.perimeter }
