require "./maze"
require "./pathfinder"


if $PROGRAM_NAME == __FILE__
  pf = Pathfinder.new(ARGV.shift)

end
