require_relative "maze"
require_relative "pathfinder"


if $PROGRAM_NAME == __FILE__
  pf = Pathfinder.new( ARGV.shift, [1, 1], [1, 4] )
  pf.run
end
