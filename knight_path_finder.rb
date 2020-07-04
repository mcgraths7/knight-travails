require_relative 'polynode_tree.rb'

class KnightPathFinder
  attr_accessor :considered_positions, :current_position, :root_node

  def initialize(starting_position)
    @current_position = starting_position
    @considered = [@current_position]
    build_move_tree
  end

  def self.trace_path_back(start_node, end_node)
    path = []
    current_node = end_node
    until current_node.parent.nil?
      path.unshift(current_node.value)
      current_node = current_node.parent
    end
    path.unshift(start_node.value)
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
      valid_moves << end_position if valid_move?(end_position)
    end
    valid_moves
  end

  def find_path(end_pos)
    last_node = @root_node.dfs(end_pos)
    path = KnightPathFinder.trace_path_back(@root_node, last_node)
  end

  def new_move_positions(position)
    valid_moves = KnightPathFinder.valid_moves(position)
    new_positions = valid_moves.reject { |pos| @considered.include?(pos) }
    @considered += new_positions
    new_positions
  end

  def build_move_tree
    self.root_node = PolyTreeNode.new(@current_position)
    node_queue = [@root_node]
    until node_queue.empty?
      current_node = node_queue.shift
      current_pos = current_node.value
      new_move_positions(current_pos).each do |pos|
        child_node = PolyTreeNode.new(pos)
        current_node.add_child(child_node)
        node_queue << child_node
      end
    end
  end
end

kpf = KnightPathFinder.new([0, 0])
p kpf.find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
p kpf.find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]






