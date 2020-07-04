require_relative 'polynode_tree.rb'
require 'byebug'

class KnightPathFinder
  attr_reader :root_node, :move_tree
  attr_accessor :considered_positions, :current_position

  def initialize(starting_position)
    @root_node = PolyTreeNode.new(starting_position)
    @current_position = starting_position
    @considered_positions = [@current_position]
    @move_tree = self.build_move_tree
  end

  def self.valid_move?(position)
    return false if position[0] > 7 || position[0] < 0
    return false if position[1] > 7 || position[1] < 0
    true
  end

  def self.valid_moves(position)
    unless valid_move?(position)
      return []
    end
    x_pos, y_pos, valid_moves = position[0], position[1], []
    movements = [
      [2, 1], [2, -1], [-2, 1], [-2, -1], 
      [1, 2], [1, -2], [-1, 2], [-1, -2]
    ]
    movements.each do |movement|
      end_position = [x_pos + movement[0], y_pos + movement[1]]
      if valid_move?(end_position)
        valid_moves << end_position
      end
    end
    valid_moves
  end

  def new_move_positions(position)
    valid_moves = KnightPathFinder.valid_moves(position)
    new_positions = valid_moves.reject do |pos| 
      @considered_positions.include?(pos)
    end
    @considered_positions += new_positions
    new_positions
  end

  def build_move_tree
    move_tree = []
    node_queue = [@root_node]
    next_moves = new_move_positions(@current_position)
    until node_queue.empty?
      current_node = node_queue.shift
      current_pos = current_node.value
      next_moves.each do |pos|
        child_node = PolyTreeNode.new(pos)
        current_node.add_child(child_node)
        unless move_tree.include?(current_node)
          move_tree << current_node
        end
        node_queue << child_node
      end
      next_moves = new_move_positions(current_pos)
    end
    move_tree
  end
end

kpf = KnightPathFinder.new([0, 0])





