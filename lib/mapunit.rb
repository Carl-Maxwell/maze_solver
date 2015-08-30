class MapUnit
	attr_reader :x, :y

	def initialize map, x, y
		@map    = map
		@x, @y  = x, y

		@filled = false

		@up, @right, @down, @left = true, true, true, true
	end

	def up
		return @map[@x-1][@y] if @x > 0
		false
	end

	def right
		return @map[@x][@y+1] if @y < @map.width
		false
	end

	def down
		return @map[@x+1][@y] if @x < @map.height-1
		false
	end

	def left
		return @map[@x][@y-1] if @y > 0
		false
	end

	def open direction, recursive=true
		@filled = true

		case direction
		when :up 
			@up = false
			self.up.open(:down, false) if recursive
			self.up
		when :right
			@right = false
			self.right.open(:left, false) if recursive
			self.right
		when :down
			@down = false
			self.down.open(:up, false) if recursive
			self.down
		when :left
			@left = false
			self.left.open(:right, false) if recursive
			self.left
		end
	end

	def open_directions
		[] +
		(!@up    ? [:up]    : []) +
		(!@right ? [:right] : []) +
		(!@down  ? [:down]  : []) +
		(!@left  ? [:left]  : [])
	end

	def replicate tile
		tile.open_directions.each do |direction|
			open direction
		end
	end

	def filled?
		@filled
	end

	def xy
		[@x, @y]
	end

	def adjacent
		[] +
		(up    ? [up]    : []) +
		(right ? [right] : []) +
		(down  ? [down]  : []) +
		(left  ? [left]  : [])
	end

	def connections
		output = {}
		output[:up]    = up    if !@up
		output[:right] = right if !@right
		output[:down]  = down  if !@down
		output[:left]  = left  if !@left
		return output
	end

	def adjacent? other_node
		(other_node.x == @x && (other_node.y - @y).abs == 1) || (other_node.y == @y && (other_node.x - @x).abs == 1)
	end

	def display ith
		[
			"*" + (@up ? "*" : " ") + "*",
			(@left ? "*" : " ") + " " + (@right ? "*" : " "),
			"*" + (@down ? "*" : " ") + "*"
		][ith]
	end
end