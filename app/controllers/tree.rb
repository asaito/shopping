#!/usr/local/bin/ruby -w

=begin
= tree.rb
 ver.0.1 Aug.24.2000 create
 ver.0.2 Aug.25.2000 these methods added
		include?, is_brother?, depth, is_descendant?,
		is_ancestor?, relationship, children, parents
=end

class Tree
	ERRFMT = "%s isn't a tree member"

	def initialize(ary = nil)
		@children = Hash.new([])
		@parents = Hash.new([])
		self << ary if ary
	end

	def include?(item)
		@parents.has_key?(item) || @children.has_key?(item)
	end

	def <<(ary)
		parent = nil
		ary.each do |x|
			if parent
				@children[parent] += [x] unless @children[parent].include?(x)
				@parents[x] += [parent] unless @parents[x].include?(parent)
			end
			parent = x
		end
	end

	def sibling(item)
		if @parents.has_key?(item)
			@children[@parents[item][0]] - [item]
		elsif @children.has_key?(item)	# top
			[]
		else
			raise ERRFMT % item
		end
	end

	def is_brother?(one, another)
		raise ERRFMT % another unless include?(another)
		sibling(one).include?(another)
	end
	alias is_sister? is_brother? 

	def depth(item)
		raise ERRFMT % another unless include?(item)
		depth = 0
		while @parents[item] != []
			item = @parents[item][0]
			depth += 1
		end
		depth
	end

	def is_descendant?(one, another)	# is one a descendant of another?
		return false if is_brother?(one, another)
		return false if depth(one) < depth(another)
		while @parents[one] != []
			return true if @parents[one][0] === another
			one = @parents[one][0]
		end
		false
	end

	def is_ancestor?(one, another)	# is one an ancestor of another ?
		is_descendant?(another, one)
	end

	def relationship(one, another)
		return "brother or sister" if is_brother?(one, another)
		return "ancestor" if is_ancestor?(one, another)
		return "descendant" if is_descendant?(one, another)
		return "unknown relation"
	end

	def roots
		@children.keys - @parents.keys
	end

	def children(item)
		if @children.has_key?(item)
			@children[item]
		elsif @parents.has_key?(item)
			[]
		else
			raise ERRFMT % item
		end
	end

	def parents(item)
		if @parents.has_key?(item)
			@parents[item]
		elsif @children.has_key?(item)
			[]
		else
			raise ERRFMT % item
		end
	end

	def to_s(limit = nil, fmt = "%s+- %s\n", indent = "  ")
		@fmt = fmt
		@indent = indent
		@limit = nil
		@limit = @indent * limit if limit
		result = ""
		roots.each do |x|
			result += _subtree(x, "")
		end
		result
	end

private
	def _subtree(node, depth)
		result = @fmt % [depth, node]
		depth += @indent
		return result + @fmt % [depth, "..."] if @limit && @limit < depth
		@children[node].each do |x|
			if @children.has_key?(x)
				result += _subtree(x, depth)
			else
				result += @fmt % [depth, x]
			end
		end
		result
	end
end

if __FILE__ == $0
	tree = Tree.new
	Module.constants.sort.each do |x|
		eval <<-EOT
			if #{x}.is_a?(Class) then
				tree << #{x}.ancestors.reverse
			end
		EOT
	end
	print tree.to_s(3)
	print tree
	p tree

	p tree.sibling(Array)
	tree.sibling(Array).each do |x|
		p x
	end
end

