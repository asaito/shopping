# -*- encoding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_malladmin!
  #$checked = ' '

  def check2digit(digit)
    s = digit.to_s
    if s.size == 1
      s = "0" + s
    end
    s
  end

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
      #return #####
    end
    $ctgrymtbl_changed = 0
    get_ctg_list
    @children = $children
    @parents = $parents
    path = './'
    #logd('list $parents:', '')
    #logd('', $parents)
    #logd('list $children:', '')
    #logd('', $children)

    $htmlstr = ""
    d = ls_tree(path)
    #logd('$htmlstr:', $htmlstr)
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
      #if first == 1
        first = 0
      #else
        #logd('              ', ctg.ctgryname)
        #logd('path:', ctg.path)
        ary[i] = ctg.path.split(/\//)
        @name_ary[i] = ctg.ctgryname
        #logd('path name:', ctg.path + "          " + @name_ary[i])
        i += 1
      #end
    end
    sortctg(ary, @name_ary, i)
    arry
  end

  def sortctg(ary, name_ary, i)
    #logd('i:', i.to_s)
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
      for l in 0..pathsize - 1
        #logd('bf ary['+j.to_s+']['+l.to_s+']:', ary[j][l])
      end
    end

    ctgname_ary = ary.clone
    ctg_ary = Array.new

    logd('before cd_to_name ary:', '')
    for j in 0..i - 1
      #logary('ary', ary[j], j)
    end

    cd_to_name(ary, @ctgcd_ary, ctgname_ary, name_ary, i)

    logd('after cd_to_name ary:', '')
    for j in 0..i - 1
      #logary('ary', ary[j], j)
    end
    #logd("ary[0][0]", ary[0][0])
    #logd('ctgname_ary:', ctgname_ary)
    #logd('name_ary:', name_ary)

    seq = 0
    cur = 0
    cont = Array.new()
    for j in 0 .. i - 1
      t = Array.new
      for k in 0..pathsize - 1
        if ary[j][k] != nil
          #logd("mn ary["+j.to_s+"]["+k.to_s+"] ary["+j.to_s+"]["+(k-1).to_s+"]:", ary[j][k].to_s+' '+(k==0 ? "" : to_s_nil(ary[j][k-1])))
          if k == 1 && ary[j][k - 1] == "0"   #####
            t << '/'
          end
          t << ary[j][k]
          if ary[j][k + 1] == nil
            ctg_ary[j] = ary[j][k]
          end
        end
      end
      #logcont('t', t)
      $tree << t
      #logd('$tree:', '')
      #logd('', $tree)
    end
    #logcont('@ctgcd_ary:', @ctgcd_ary)
    logd('after tree ary:', '')
    for j in 0..i - 1
      #logary('ary'+'['+j.to_s+']:', ary[j], j)
    end
    logd('after tree ctgname_ary:', '')
    #logd('$tree:', '')
    #logd('', $tree)
    
    @cnt_ary = cmsum_count(name_ary)
    #logd("@cnt_ary.size:", @cnt_ary.size)
    #logd('@cnt_ary:', @cnt_ary)
  end

  def ls_tree(path)
    d = $tree.roots
    @count = 0
    #logd('$tree.root:', d)
    #logd('@depth:', @depth)
    #logcont('d[0]::', d[0])
    #logd('@name_ary:', @name_ary)
    #logd('@ctgcd_ary:', @ctgcd_ary)
    _sbtree(d[0])
    #logd('@count:', @count)
    $htmlstr << "\n" + gettab(@depth) + "</li>"
    $htmlstr << "\n" + gettab(@depth) + "</ul>"
    $tree
  end

  def _sbtree(node)
    url = "../cmdtylists?ctgrycode="
    ctcd = ""
    if $from_cmdtylists == 0
      ctcd = "(" + getctgcd(@ctgcd_ary, @name_ary, node).to_s + ")"
    end
    if @depth == 0
      $htmlstr << "\n<ul id=\"navigation\" class=\"navigation\">"
      $htmlstr << "\n" + gettab(@depth) + "<li>"
      if $from_cmdtylists == 0
	$htmlstr << "<a href=\"" + node + "\">" + node + "</a>" + "【 "+ getctg_count(@cnt_ary, @name_ary, node).to_s + "件】(" + getctgcd(@ctgcd_ary, @name_ary, node).to_s + ")"
      else
	$htmlstr << "<a href=" + url + getctgcd(@ctgcd_ary, @name_ary, node).to_s + ">" + node + "</a>" + "【 "+ getctg_count(@cnt_ary, @name_ary, node).to_s + "件】" + ctcd
      end
      $htmlstr << "\n" + gettab(@depth) + "<ul>"
    else
        $htmlstr << "\n" + gettab(@depth) + "<ul>"
    end
    @depth += 1
    $children[node].map do |c|
      if $from_cmdtylists == 0
	ctcd = "(" + getctgcd(@ctgcd_ary, @name_ary, c).to_s + ")"
      end
      $htmlstr << "\n" + gettab(@depth) + "<li>"
      if $from_cmdtylists == 0
	$htmlstr << "<a href=\"" + c + "\">" + c + "</a>" + "【 "+ getctg_count(@cnt_ary, @name_ary, c).to_s + "件】(" + getctgcd(@ctgcd_ary, @name_ary, c) + ")" 
      else
	$htmlstr << "<a href=" + url + getctgcd(@ctgcd_ary, @name_ary, c).to_s + ">" + c + "</a>" + "【 "+ getctg_count(@cnt_ary, @name_ary, c).to_s + "件】" + ctcd
      end
      classes = "file"
      classes = "folder" if $children.has_key?(c)
      hasChildren = $children.has_key?(c) ? true : false
      iddata = './/' + c
      dirname = $parents[c][0]
      #logcont('$children[c]:', $children[c])
      if hasChildren
        @count = _sbtree(c)
        $htmlstr << "\n" + gettab(@depth) + "</li>"
      else
        @count += 1
        $htmlstr << "</li>"
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
        #if ary[j][k] != nil && ary[j][k] != 0
        if ary[j][k] != nil #&& ary[j][k] != 0
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
    #if ctgcd == '/' #不要？
    #  return '/'    #不要？
    #end		    #不要？
    for i in 0..ctgcd_ary.size - 1
      if ctgcd_ary[i] == ctgcd
        return name_ary[i]
      end
    end
  end

  def getctgcd(ctgcd_ary, name_ary, ctgname)
    #if ctgname == '/'
     # return '/'
    #end
    for i in 0..ctgcd_ary.size - 1
      if name_ary[i] == ctgname
        return ctgcd_ary[i]
      end
    end
    return '/'
  end

  def cmsum_count(name_ary)
    cnt_ary = Array.new
    name_ary.each do |nm|
      @where = ""
      where = cmsum_where(nm)
      where = where[4, where.length - 4]
      #logd("where:", where)
      sql = "select count(distinct cmdtycode) from cmdtyctgry_ctgry_views where " + where
      cnt_ary.push(CmdtyCtgryView.count_by_sql(sql))
    end
    cnt_ary
  end

  def cmsum_where(nm)
    @where += " or ctgryname = '" + nm + "'"
    $children[nm].map do |n|
      hasChildren = $children.has_key?(n)
      if $children.has_key?(n)
	cmsum_where(n)
      else
	@where += " or ctgryname = '" + n + "'"
      end
    end
    @where
  end

  def getctg_count(cnt_ary, name_ary, ctgname)
    for i in 0..name_ary.size - 1
      if name_ary[i] == ctgname
        return cnt_ary[i]
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
=begin
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
=end
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


