# -*- encoding: utf-8 -*-
class CtgrymtblsController < ApplicationController
  # GET /ctgrymtbls
  # GET /ctgrymtbls.xml
  def index
    @ctgrymtbls = Ctgrymtbl.all
    $tree = Tree.new
    @name_ary = Array.new
    @ctgcd_ary = Array.new
    @depth = 0
    list_tree

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ctgrymtbls }
    end
  end

  # GET /ctgrymtbls/1
  # GET /ctgrymtbls/1.xml
  def show
    @ctgrymtbl = Ctgrymtbl.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ctgrymtbl }
    end
  end

  # GET /ctgrymtbls/new
  # GET /ctgrymtbls/new.xml
  def new
    @ctgrymtbl = Ctgrymtbl.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ctgrymtbl }
    end
  end

  # GET /ctgrymtbls/1/edit
  def edit
    @ctgrymtbl = Ctgrymtbl.find(params[:id])
  end

  # POST /ctgrymtbls
  # POST /ctgrymtbls.xml
  def create
    @ctgrymtbl = Ctgrymtbl.new(params[:ctgrymtbl])

    respond_to do |format|
      if @ctgrymtbl.save
        format.html { redirect_to(@ctgrymtbl, :notice => 'Ctgrymtbl was successfully created.') }
        format.xml  { render :xml => @ctgrymtbl, :status => :created, :location => @ctgrymtbl }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ctgrymtbl.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ctgrymtbls/1
  # PUT /ctgrymtbls/1.xml
  def update
    @ctgrymtbl = Ctgrymtbl.find(params[:id])

    respond_to do |format|
      if @ctgrymtbl.update_attributes(params[:ctgrymtbl])
        format.html { redirect_to(@ctgrymtbl, :notice => 'Ctgrymtbl was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ctgrymtbl.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ctgrymtbls/1
  # DELETE /ctgrymtbls/1.xml
  def destroy
    @ctgrymtbl = Ctgrymtbl.find(params[:id])
    @ctgrymtbl.destroy

    respond_to do |format|
      format.html { redirect_to(ctgrymtbls_url) }
      format.xml  { head :ok }
    end
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

  def list_tree
    logger.debug 'come to list_tree:'
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
    #$htmlstr = ''

    $htmlstr = ""
    d = ls_tree(path)
    logd('$htmlstr:', $htmlstr)
    #logcont("@arry:", @arry)
    #render "*/*" => $tree.to_s || [], :layout => false
    #render :json => @arry || [], :layout => false
    #$tree.to_s
    #@htmlstr = $tree.to_s
  end

protected
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

  def ctg_list(path, arry=[], root_flg=false)
    logger.debug 'path:' + path
    @ctgrylists = Ctgrylist.find_by_sql(["select * from ctg_paths order by ctgryname, path;"])
    @ctgrylistssort = Ctgrylist.new
    ary = Array.new
    #name_ary = Array.new
    #@tree = Tree.new
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

    #treelist(@tree, arry)
    #treelist1(path, arry)
    arry
    #tree
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
      #t << '<ul>\n' + '/' + '<li>\n'
	  end
	  t << ary[j][k]
    #depth = ''
    #(k - 1).times{depth += '\t'}
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
    #$htmlstr = tree_to_html($tree)
    
    #logd('$parents:', '')
    #logd('', $parents)
    #logd('$children:', '')
    #logd('', $children)

    #logd('name tree:', '')
    #logd('', $tree.to_s2(3, fmt = "%s %s\n", ctg_ary, name_ary))
    #logd('', $tree.to_s2(3, fmt = "%s %s\n", ctg_ary, name_ary))
  end

  def tree_to_html(items)
    tab = ""
    @depth += 1
    if items != nil
      if @depth == 1
        html = "\n<ul id=\"red\" class=\"treeview-red\">"
      else
        for i in 0..@depth - 1
          tab += "\t"
        end
        html = "\n" + tab + "<ul>"
      end
      items.each do |item|
        html << "\n" + tab + "<li>"
        html << "<span>" + h(item.name) + "</span>"
        if item.children.size > 0
          html << list_trees(item.children)
        end
        html << "</li>"
      end
      html << "</ul>"
    end
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

  def treelist(tree, arry)
    tree.map do |d|
      classes = "file"
      classes = "folder" if FileTest.directory?(d)
      hasChildren = (FileTest.directory?(d)) ? true : false
      h = {"id" => d, "text" => File.basename(d), "path" => File.dirname(d), "expanded" => false, "classes" => classes, "hasChildren" => hasChildren, "children" => []}
      arry << h
    end
  end

  def treelist1(path, arry)  
    Dir.glob("#{path}/*").map do |d|
    #@ctgrylists.map do |d|
      classes = "file"
      classes = "folder" if FileTest.directory?(d)
      hasChildren = (FileTest.directory?(d)) ? true : false
      h = {"id" => d, "text" => File.basename(d), "path" => File.dirname(d), "expanded" => false, "classes" => classes, "hasChildren" => hasChildren, "children" => []}
      arry << h
    end
  end

  def get_dir_list
    logger.debug 'get_dir_list:'
    root_flg = (params["root"] == "source") ? true : false
    path = "./"
    path = params["root"] unless root_flg
    arry = []
    d = dir_list(path, arry)
    logcont('dir_list arry:', arry)
    render :json => arry || [], :layout => false
  end
 
  def dir_list(path, arry=[], root_flg=false)
    Dir.glob("#{path}/*").map do |d|
      classes = "file"
      classes = "folder" if FileTest.directory?(d)
      hasChildren = (FileTest.directory?(d)) ? true : false
      h = {"id" => d, "text" => File.basename(d), "path" => File.dirname(d), "expanded" => false, "classes" => classes, "hasChildren" => hasChildren, "children" => []}
      arry << h
    end
    arry
  end

end
