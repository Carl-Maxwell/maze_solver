require './pathfinder_memory'
require './libraries/vector'
require './pathpicker'
require './libraries/weighted_sample'

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

  def pick_goal
    pool = self.memory.frontier

    pool = pool.sort_by { |coord| self.position.distance(Vector.new(coord)) }

    self.goal = Vector.new(pool.weighted_sample)
  end

  def pick_path
    pick_goal

    valid_tiles = (
      self.memory.coords.select { |coord| self.maze.at(coord) } +
      self.memory.frontier
    )

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
    log = []
    while self.memory.coords.length < self.maze.to_a.flatten.length
      system("clear")
      puts self.maze.to_s( {
        self.position.to_a => "P".on_red,
        self.goal.to_a => "G".on_green,
        self.stop.to_a => "E".on_cyan,
        self.stop.to_a => "S".blue
      } )
      self.tick
      log << [self.position.to_a, self.goal.to_a]
      #puts log.map(&:inspect).join("\n")
      sleep(0.2)
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
