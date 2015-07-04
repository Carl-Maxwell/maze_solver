require 'set'
require './tree_node'
require './vector'

class PathPicker
  attr_accessor :visited_positions, :move_tree, :valid_positions

  def initialize(start_position, valid_positions)
    @visited_positions = Set.new
    visited_positions.add(start_position)
    @valid_positions = valid_positions

    @move_tree = build_move_tree(start_position)
  end

  def new_move_positions(pos)
    new_moves = valid_moves(pos).reject { |move| visited_positions.include?(move) }
    self.visited_positions.merge(new_moves)
    new_moves
  end

  def valid_moves(pos)
    Vector.new(pos).adjacent & self.valid_positions
  end

  def build_move_tree(starting_position)
    root = TreeNode.new(starting_position)

    queue = Queue.new
    queue.enqueue(root)
    until queue.length == 0
      node = queue.dequeue
      position = node.value
      new_move_positions(position).each do |pos|
        child_node = TreeNode.new(pos)
        node.add_child(child_node)
        queue.enqueue(child_node)
      end
    end
    root
  end

  def find_path(end_position)
    ending = self.move_tree.bfs(end_position)
    return ending.trace_path if ending
    #raise "Could not find path!"
  end
end
