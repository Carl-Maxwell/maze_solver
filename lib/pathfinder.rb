require_relative 'pathfinder_memory'
require_relative 'libraries/vector'
require_relative 'pathpicker'
require_relative 'libraries/weighted_sample'
require 'byebug'

class Pathfinder
  attr_accessor :position, :stop, :goal, :path
  attr_reader :maze, :memory

  def initialize maze, start, stop
    @position = Vector.new(start)
    @stop = Vector.new(stop)
    @goal = position

    @memory = PathfinderMemory.new(position.to_a)

    @maze = Maze.new(maze, memory)

    @memory.width  = @maze.width
    @memory.height = @maze.height

    @path = []
  end

  def valid_tiles
    @valid_tiles ||= (self.memory.coords + self.memory.frontier)
    .select { |coord| self.maze.at(coord) }
  end

  def pick_goal
    picker = PathPicker.new(self.position.to_a, valid_tiles)

    # pool = self.memory.frontier.select do |coord|
    #   picker.find_path(coord)
    # end

    # weights = pool.dup.map { |coord| picker.find_path(coord).length }
    # w = weights.max

    # weights.map! { |l| 1 + (w - l) }

    # self.goal = Vector.new(pool.weighted_sample(weights))

    self.goal = Vector.new(self.memory.frontier.min_by { |coord|
      p = picker.find_path(coord)
      p ? p.length : Float::INFINITY
    } )
  end

  def pick_path
    @valid_tiles = nil

    pick_goal

    picker = PathPicker.new(self.position.to_a, valid_tiles)
    maybe_path = picker.find_path(self.goal.to_a)

    if maybe_path
      self.path = maybe_path[1..-1]
    else
      pick_path
    end
  end

  def tick
    if self.path.empty?
      pick_path
    end

    # step = self.position + Vector.new(step_towards(self.position, self.path.shift))
    step = self.path.shift

    memory.fill( *step )

    if maze.at(step)
      self.position = Vector.new(step)
    else
      pick_path
    end
  end

  def run
    while self.memory.coords.length < self.maze.to_a.flatten.length
      special_chars = self.memory.frontier.dup.select { |coord| self.maze.at(coord) }
      special_chars = Hash[special_chars.collect { |v| [v, " ".on_green] }]
      output = self.maze.render( special_chars.merge( {
        self.goal.to_a     => "G".on_green,
        self.stop.to_a     => "E".on_cyan,
        self.stop.to_a     => "S".blue,
        self.position.to_a => "P".on_red
      } ) )

      system("clear")
      puts output
      self.tick
      # sleep(0.2)
    end
  end

  def step_towards(vec1, vec2)
    diff = vec2 - vec1
    size = diff.to_a.map(&:abs).max
    diff /= size if size != 0
    output = diff.to_a.map { |n| n.abs != 1 ? 0 : n  }

    return output if output.any? { |n| n == 0 }

    output[rand(2)] = 0
    output
  end
end
