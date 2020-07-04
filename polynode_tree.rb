module Searchable
    def dfs(target = nil, &prc)
    raise "Need proc or target" if [target, prc].none?
    prc ||= Proc.new { |node| node.value == target }
    return self if prc.call(self)
    children.each do |child|
      result = child.dfs(&prc)
      return result unless result.nil?
    end
    nil
  end

  def bfs(target = nil, &prc)
    raise "Need a proc or target" if [target, prc].none?
    prc ||= Proc.new { |node| node.value == target }

    nodes = [self]
    until nodes.empty?
      node = nodes.shift

      return node if prc.call(node)
      nodes.concat(node.children)
    end

    nil
  end
end

class PolyTreeNode
  include Searchable
  attr_reader :children, :parent, :value
  def initialize(value)
    @value = value
    @children = []
    @parent = nil
  end
  
  def parent=(parent_node)
    if parent_node == @parent
      return nil
    end
    remove_self_from_old_parent
    @parent = parent_node
    add_self_to_new_parent
    @parent
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    raise "Not my child!" unless children.include?(child_node)
    child_node.parent = nil
    children.each_with_index do |child, idx|
      if child == child_node
        children.delete_at(idx)
      end
    end
  end

  def remove_self_from_old_parent
    unless @parent.nil?
      @parent.children.each_with_index do |child, idx|
        if child == self
          @parent.children.delete_at(idx)
        end
      end
    end
  end

  def add_self_to_new_parent
    @parent.children << self unless @parent.nil?
  end

end