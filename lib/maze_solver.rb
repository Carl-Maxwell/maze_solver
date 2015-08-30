require_relative "map"
require_relative "maze"
require_relative "pathfinder"

if $PROGRAM_NAME == __FILE__
  maze = ARGV.shift

  unless maze
    m = Map.new(26,10)
    m.generate()

    filename = "mazes/maze" + Dir.glob("mazes/maze*").length.to_s.rjust(2, "0")

    File.write(filename, m.display)

    maze = filename
  end

  pf = Pathfinder.new(maze, [1, 1], [1, 4])
  pf.run
end
