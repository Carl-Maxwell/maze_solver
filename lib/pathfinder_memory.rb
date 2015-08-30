class PathfinderMemory
  attr_accessor :memory, :width, :height

  def initialize(initial_value = false)
    @memory = {}
    memory[initial_value] = true if initial_value
  end

  def [](row_index)
    return at(*row_index) if row_index.is_a?(Array)
    Row.new(self, row_index)
  end

  def at(row, column)
    memory[[row, column]]
  end

  def set_at(row, column, value)
    memory[[row, column]] = !!value
  end

  def fill(row, column)
    set_at(row, column, true)
  end

  def frontier
    visited = memory.keys

    # get coords adjacent to visited elements that are not in visited
    frontier = []
    visited.each { |coord| frontier.concat(adjacent(coord)) }
    frontier
      .reject { |tile| visited.include?(tile) }
      .reject do |coord|
        next true if coord.any? { |e| e < 0 }
        coord[0] > height || coord[1] > width
      end
  end

  def coords
    @memory.keys
  end

  def adjacent(coord)
    adj = []

    (-1..1).each do |x|
      (-1..1).each do |y|
        next unless [x,y].include? 0
        adj << [coord[0] + x, coord[1] + y]
      end
    end

    adj
  end

  class Row
    attr_reader :parent, :row_index

    def initialize parent, row_index
      @parent = parent
      @row_index = row_index
    end

    def [](column_index)
      parent.at(row_index, column_index)
    end

    def []=(column_index, value)
      parent.set_at(row_index, column_index, value)
    end
  end
end
