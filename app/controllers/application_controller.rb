# -*- encoding: utf-8 -*-
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

  def logary(a, ary, j)
    str = ''
    i = 0
    while i < ary.size
      str += ary[i].to_s + ' '
      i += 1
    end
    logd(a+'['+j.to_s+']:', str)
  end

  def logcont(a, cont)
    str = ''
    i = 0
    logd(a+'.size:', cont.size.to_s)
    while i < cont.size
      str += cont[i].to_s + ' '
      i += 1
    end
    logd(a+':', str)
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
# Ctgry tree -- start
  def list_tree
    logger.debug 'come to list_tree:'
    if $ctgrymtbl_changed != nil || $ctgrymtbl_changed == 0
      #return
    end
    $ctgrymtbl_changed = 0
    get_ctg_list
    @children = $children
    @parents = $parents
    path = './'
    @arry = []
    #logd('list $tree:', '')
    #logd('', $tree)
    logd('list $parents:', '')
    logd('', $parents)
    logd('list $children:', '')
    logd('', $children)

    $htmlstr = ""
    d = ls_tree(path)
    logd('$htmlstr:', $htmlstr)
  end

  def get_ctg_list
    logger.debug 'get_ctg_list:'
    root_flg = (params["root"] == "source") ? true : false
    path = params["root"] unless root_flg
    path = "./"
    arry = []
    d = ctg_list(path, arry)
    #render :json => arry || [], :layout => false
  end

  def ctg_list(path, arry=[], root_flg=false)
    logger.debug 'path:' + path
    @ctgrylists = Ctgrylist.find_by_sql(["select * from ctg_paths order by ctgryname, path;"])
    @ctgrylistssort = Ctgrylist.new
    ary = Array.new
    i = 0
    first = 1
    @ctgrylists.each do |ctg|
      if first == 1
        first = 0
      else
        logd('              ', ctg.ctgryname)
        logd('path:', ctg.path)
        ary[i] = ctg.path.split(/\//)
        @name_ary[i] = ctg.ctgryname
        logd('name_ary:', @name_ary[i])
        i += 1
      end
    end
    sortctg(ary, @name_ary, i)
    arry
  end

  def sortctg(ary, name_ary, i)
    logd('i:', i.to_s)
    #logary('name_ary:', name_ary)
    pathsize = 0
    for j in 0..i - 1
      if pathsize < ary[j].size
        pathsize = ary[j].size
      end
      ary[j][0] = 0
    end
    logd('pathsize:', pathsize)

    for j in 0..i - 1
      for l in 0..pathsize
        logd('bf ary['+j.to_s+']['+l.to_s+']:', ary[j][l])
      end
    end

    ctgname_ary = ary.clone
    #ctgcd_ary = Array.new
    ctg_ary = Array.new

    logd('before cd_to_name ary:', '')
    for j in 0..i - 1
      logary('ary'+'['+j.to_s+']', ary[j], j)
    end

    cd_to_name(ary, @ctgcd_ary, ctgname_ary, name_ary, i)

    logd('after cd_to_name ary:', '')
    for j in 0..i - 1
      logary('ary'+'['+j.to_s+']', ary[j], j)
    end

    seq = 0
    cur = 0
    cont = Array.new()
    for j in 0 .. i - 1
      t = Array.new
      for k in 1..pathsize
        if ary[j][k] != nil
          logd("mn j k ary[][]:", j.to_s+' '+k.to_s+' '+ary[j][k].to_s+' '+to_s_nil(ary[j][k-1]))
          logd('sr ary[j][k]:', ary[j][k])
          if k == 1 && ary[j][k + 1] == nil
            t << '/'
          end
          t << ary[j][k]
          if ary[j][k + 1] == nil
            ctg_ary[j] = ary[j][k]
          end
        end
      end
      logcont('t', t)
      $tree << t
    end
    logcont('@ctgcd_ary:', @ctgcd_ary)
    logd('after tree ary:', '')
    for j in 0..i - 1
      logary('ary'+'['+j.to_s+']:', ary[j], j)
    end
    logd('after tree ctgname_ary:', '')
    for j in 0..i - 1
      #logary('ctgname_ary'+'['+j.to_s+']:', ctgname_ary[j], j)
    end
    logd('$tree:', '')
    logd('', $tree)
    logd('$tree.to_s:', $tree.to_s)
  end

  def ls_tree(path)
    d = $tree.roots
    @count = 0
    logd('$tree.root:', d)
    _sbtree(d[0])
    logd('@count:', @count)
    $htmlstr << "\n" + gettab(@depth) + "</li>"
    $htmlstr << "\n" + gettab(@depth) + "</ul>"
    #logcont('@arry', @arry)
    #@arry
    $tree
  end

  def _sbtree(node)
    if @depth == 0
      $htmlstr << "\n<ul id=\"navigation\" class=\"navigation\">"
      $htmlstr << "\n" + gettab(@depth) + "<li>"
      $htmlstr << "<a href=\"" + "基本" + "\">" + "基本" + "</a>" +
                  "【 "+ "件】(" + getctgcd(@ctgcd_ary, @name_ary, node) + ")"
      $htmlstr << "\n" + gettab(@depth) + "<ul>"
    else
        $htmlstr << "\n" + gettab(@depth) + "<ul>"
    end
    @depth += 1
    logcont('$children[node]:', $children[node])
    $children[node].map do |c|
      $htmlstr << "\n" + gettab(@depth) + "<li>"
      $htmlstr << "<a href=\"" + c + "\">" + c + "</a>" +
                  "【 "+ "件】(" + getctgcd(@ctgcd_ary, @name_ary, c) + ")"
      classes = "file"
      classes = "folder" if $children.has_key?(c)
      hasChildren = $children.has_key?(c) ? true : false
      iddata = './/' + c
      #dirname = '.'
      dirname = $parents[c][0]
      #logger.debug 'iddata:'+ iddata
      logcont('$children[c]:', $children[c])
      h = {"id" => iddata, "text" => c, "path" => dirname, "expanded" => false, "classes" => classes, "hasChildren" => hasChildren, "children" => []}
      if hasChildren
        @arry << h
        @count = _sbtree(c)
        $htmlstr << "\n" + gettab(@depth) + "</li>"
        logcont('@arry', @arry)
      else
        @count += 1
        $htmlstr << "</li>"
        @arry << h
      end
    end
    @depth -= 1
    $htmlstr << "\n" + gettab(@depth) + "</ul>"
    return @count
  end

  def cd_to_name(ary, ctgcd_ary, ctgname_ary, name_ary, i)
    set_ctg_ary(ary, ctgcd_ary, ctgname_ary, name_ary, i)
    for j in 0..i - 1
      for k in 0..ary[j].size
        a = Array.new
        if ary[j][k] != nil && ary[j][k] != 0
          ctgname_ary[j][k] = getname(ctgcd_ary, name_ary, ary[j][k])
        end
      end
    end
  end

  def set_ctg_ary(ary, ctgcd_ary, ctgname_ary, name_ary, i)
    for j in 0..i - 1
      for k in 0..ary[j].size - 1
        if ary[j][k] != nil && ary[j][k + 1] == nil
          ctgcd_ary[j] = ary[j][k]
        end
      end
    end
  end

  def gettab(depth)
    if depth == 0
      return ""
    end
    tab = ""
    for i in 0..depth - 1
      tab += "\t"
    end
    return tab
  end

  def getname(ctgcd_ary, name_ary, ctgcd)
    if ctgcd == '/'
      return '/'
    end
    for i in 0..ctgcd_ary.size - 1
      if ctgcd_ary[i] == ctgcd
        return name_ary[i]
      end
    end
  end

  def getctgcd(ctgcd_ary, name_ary, ctgname)
    if ctgname == '/'
      return '/'
    end
    for i in 0..ctgcd_ary.size - 1
      if name_ary[i] == ctgname
        return ctgcd_ary[i]
      end
    end
  end
# Ctgry tree -- end

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
    $children = Hash.new([])
    @parents = Hash.new([])
    $parents = Hash.new([])
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
	$children = @children
	$parents = @parents
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

  def hasChildren?(item)
    if @parents.has_key?(item)
      return true
    else
      return false
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
    #stlogger.debug 'name_tree3:' + name_tree
    name_tree
  end
  #def to_s2(limit = nil, fmt = "%s+- %s\n", indent = "  ", ctg_ary, name_ary)
  def to_s2(limit = nil, fmt = "%s %s\n", indent = "  ", ctg_ary, name_ary)
    @fmt = fmt
    @indent = indent
    #@indent = "\t"
    @limit = nil
    @limit = @indent * limit if limit
    name_tree = ""
    result = ""
    roots.each do |x|
      wk, wk1 = _subtree2(x, "", ctg_ary, name_ary)
      name = getname(ctg_ary, name_ary, x)
      name_tree = name_tree + wk1 + name
      #logger.debug 'name:' + name
      #logger.debug 'name_tree2:' + name_tree
      result += wk
    end
    #result
    #stlogger.debug 'name_tree3:' + name_tree
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
	#logger.debug 'wk1:' + wk1
	#logger.debug 'name1:' + name
	#logger.debug 'name_tree0:' + name_tree
	name_tree = name_tree + name + wk1
	#logger.debug 'name_tree1:' + name_tree
        result += wk
      else
	name = getname(ctg_ary, name_ary, x)
	#logger.debug 'name1:' + name
	#logger.debug 'name_tree1:' + name_tree
        name_tree += @fmt % [depth, name]
	#logger.debug 'name:' + name
	#logger.debug 'name_tree:' + name_tree
        result += @fmt % [depth, x]
      end
    end
    #result
    return result, name_tree
  end

  def _subtree2(node, depth, ctg_ary, name_ary)
    result = @fmt % [depth, node]
    name_tree = @fmt % [depth, node]
    depth += @indent
    return result + @fmt % [depth, "..."], result + @fmt % [depth, "..."] if @limit && @limit < depth
    @children[node].each do |x|
      if @children.has_key?(x)
        wk, wk1 = _subtree2(x, depth, ctg_ary, name_ary)
        name = getname(ctg_ary, name_ary, x)
        logger.debug 'wk1:' + wk1
        logger.debug 'name1:' + name
        logger.debug 'name_tree0:' + name_tree
        #logger.debug '$htmlstr:' + $htmlstr
        name_tree = name_tree + name + wk1
	#name_tree = '<ul>\n' + depth + name + '<li>\n'
        logger.debug 'name_tree1:' + name_tree
        result += wk
      else
        name = getname(ctg_ary, name_ary, x)
        #logger.debug 'wk1:' + wk1
        #logger.debug 'name1:' + name
        #logger.debug 'name_tree1:' + name_tree
        name_tree += @fmt % [depth, name]
	#name_tree += '<ul>\n' + depth + name + '<li>\n' + '</ul>\n'
        logger.debug 'name:' + name
        #logger.debug 'name_tree:' + name_tree
        #logger.debug '$htmlstr:' + $htmlstr
        result += @fmt % [depth, x]
      end
    end
    #result
    return result, name_tree
  end

  def getname(ctgcd_ary, name_ary, ctgcd)
    if ctgcd == '/'
      return '/'
    end
    for i in 0..ctgcd_ary.size - 1
      if ctgcd_ary[i] == ctgcd
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


