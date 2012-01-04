class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_malladmin!
  #$checked = ' '
  def logd(a, b)
    if a == nil && b == nil
      logger.debug 'nil' + 'nil'
    elsif a != nil && b == nil
      logger.debug a + 'nil'
    elsif a == nil && b != nil
      if b.to_s == ' '
	logger.debug 'nil' + 'B'
      else
	logger.debug 'nil' + b.to_s
      end
    else
      if b.to_s == ' '
	logger.debug a + 'B'
      else
	logger.debug a + b.to_s
      end
    end
  end

  def logary(a, b)
    if a == nil && b == nil
      logger.debug 'nil' + 'nil'
    elsif a != nil && b == nil
      logger.debug a + 'nil'
    elsif a == nil && b != nil
      logger.debug 'nil' + concats(b)
    else
      logger.debug a + concats(b)
    end
  end 
  def concats(b)
      s = ''
      for i in 0..b.size - 1
	if b[i] == nil
	  s += 'N' + ' '
	else
	  s += b[i].to_s + ' '
	end
      end
      s
  end
  
  def to_s_nil(a)
    if a == nil
      return 'nil'
    end
    return a.to_s
  end
end

class CtgNet < ActionController::Base
  @@ctgcd = ''
  @@next = 0

  def setctgcd(n)
    @@ctgcd = n
  end
  def getctgcd
    @@ctgcd
  end
  def setnext(n)
    @@next = n
  end
  def getnext
    @@next
  end
  
end

class Contnet < ActionController::Base
  @@top = 0
  @@end = 0
  #def intialize
   # @@top = 0
   # @@end = 0
  #end

  def settop(n)
    @@top = n
  end
  def gettop
    @@top
  end
  def setend(n)
    @@end = n
  end
  def getend
    @@end
  end
  
  def appendNet(ctgcd)
    e = CtgNet.new()
    e.setctgcd(ctgcd)
    e.setnext(0)
    
    if @@top == 0
      logger.debug 'come to here:'
      @@top = e
    else
      @@end.setnext(e)
    end
    @@end = e
    #logd('top:', @@top.getctgcd.to_s)
  end

  def listNet
    #logd('top end:', @@top.to_s+' '+@@end.to_s)
    if gettop == 0
      return
    end
    cur = gettop
    str = ''
    str = cur.getctgcd
    logd('cur:', cur.to_s)
    logd('str:', str.to_s)
    i = 0
    while cur != 0 || i < 8
      str = str + cur.getctgcd + ' '
      cur = cur.getnext
      logd('str:', str)
      logd('cur:', cur)
      i +=1
    end
    logger.debug 'list:' + str
  end

end

#!/usr/local/bin/ruby -w

=begin
= tree.rb
 ver.0.1 Aug.24.2000 create
 ver.0.2 Aug.25.2000 these methods added
    include?, is_brother?, depth, is_descendant?,
    is_ancestor?, relationship, children, parents
=end

class Tree  < ActionController::Base
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
    elsif @children.has_key?(item)  # top
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

  def is_descendant?(one, another)  # is one a descendant of another?
    return false if is_brother?(one, another)
    return false if depth(one) < depth(another)
    while @parents[one] != []
      return true if @parents[one][0] === another
      one = @parents[one][0]
    end
    false
  end

  def is_ancestor?(one, another)  # is one an ancestor of another ?
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
  
  def to_s1(limit = nil, fmt = "%s+- %s\n", indent = "  ", ctg_ary, name_ary)
    @fmt = fmt
    @indent = indent
    @limit = nil
    @limit = @indent * limit if limit
    name_tree = ""
    result = ""
    roots.each do |x|
      wk, wk1 = _subtree1(x, "", ctg_ary, name_ary)
      name = getname(ctg_ary, name_ary, x)
      name_tree = name_tree + wk1 + name
      #logger.debug 'name:' + name
      #logger.debug 'name_tree2:' + name_tree
      result += wk
    end
    #result
    #logger.debug 'name_tree3:' + name_tree
    name_tree
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

  def _subtree1(node, depth, ctg_ary, name_ary)
    result = @fmt % [depth, node]
    name_tree = @fmt % [depth, node]
    depth += @indent
    return result + @fmt % [depth, "..."], result + @fmt % [depth, "..."] if @limit && @limit < depth
    @children[node].each do |x|
      if @children.has_key?(x)
	wk, wk1 = _subtree1(x, depth, ctg_ary, name_ary)
	name = getname(ctg_ary, name_ary, x)
	logger.debug 'wk1:' + wk1
	logger.debug 'name1:' + name
	logger.debug 'name_tree0:' + name_tree
	name_tree = name_tree + name + wk1
	logger.debug 'name_tree1:' + name_tree
        result += wk
      else
	name = getname(ctg_ary, name_ary, x)
	#logger.debug 'name1:' + name
	#logger.debug 'name_tree1:' + name_tree
        name_tree += @fmt % [depth, name]
	logger.debug 'name:' + name
	logger.debug 'name_tree:' + name_tree
        result += @fmt % [depth, x]
      end
    end
    #result
    return result, name_tree
  end

  def getname(ctg_ary, name_ary, ctgcd)
    if ctgcd == '/'
      return '/'
    end
    for i in 0..ctg_ary.size - 1
      if ctg_ary[i] == ctgcd
	return name_ary[i]
      end
    end
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


