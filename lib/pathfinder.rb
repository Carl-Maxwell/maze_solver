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

    @memory.fill(*start)

    @path = []
  end

  def valid_tiles
    @valid_tiles ||= (self.memory.coords + self.memory.frontier)
    .select { |coord| self.maze.at(coord) }
  end

  def pick_path
    @valid_tiles = nil

    picker = PathPicker.new(position.to_a, valid_tiles)

    full_path = picker.find_target_and_path(position.to_a, memory.frontier)

    self.path = full_path[1..-1]
    self.goal = full_path[0]

    path
  end

  def tick
    if self.path.empty?
      pick_path
    end

    step = self.path.shift

    memory.fill( *step )

    if maze.at(step)
      self.position = Vector.new(step)
    else
      pick_path
    end
  end

  def run
    this_frame_timestamp = Time.now.to_f

    while self.memory.coords.length < self.maze.to_a.flatten.length
      last_frame_timestamp = this_frame_timestamp
      this_frame_timestamp = Time.now.to_f

      time = this_frame_timestamp - last_frame_timestamp

      special_chars = self.memory.frontier.dup.select { |coord| self.maze.at(coord) }
      special_chars = Hash[special_chars.collect { |v| [v, " ".on_green] }]
      output = self.maze.render( special_chars.merge( {
        self.goal.to_a     => "G".on_green,
        self.stop.to_a     => "E".on_cyan,
        self.stop.to_a     => "S".blue,
        self.position.to_a => "P".on_red
      } ) )

      output += "\n#{time} seconds\n"

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
