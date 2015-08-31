
require_relative "mapunit"

class Map
	attr_accessor :width, :height, :nodes

	def initialize width, height
		@width  = width
		@height = height

		@nodes = Array.new(@height).map.with_index do |elem, x|
			Array.new(@width).map.with_index do |rawr, y|
				MapUnit.new(self, x, y)
			end
		end
	end

	def [] x
		@nodes[x]
	end

	def display
		lines = Array.new(@height * 3, "")
		@height.times do |y|
			@width.times do |x|
				3.times do |i|
					lines[y*3 + i] += @nodes[y][x].display(i)
				end
			end
		end

		lines[-2][-2] = "S"
		lines[1][1]   = "E"

		lines.join("\n").gsub("*", "\u2588") + "\n"
	end

	def filled
		@nodes.flatten.select { |node| node.filled? }
	end

	def generate
		x, y = [0, 0]

		frontier = [@nodes[x][y]]

		while frontier.length > 0
			node = frontier.shuffle.shift

			choices = []

			choices.push(:up)    if node.up    && node.up.filled?
			choices.push(:right) if node.right && node.right.filled?
			choices.push(:down)  if node.down  && node.down.filled?
			choices.push(:left)  if node.left  && node.left.filled?

			node.open(choices.shuffle![0])

			frontier = @nodes.flatten.select { |node| !node.filled? && node.adjacent.any? { |elem| elem.filled? } }
		end
	end
end
