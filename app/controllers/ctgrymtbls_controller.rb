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
    #if $showsw == 0
      list_tree
    #end
    @paramsCtgrySearchCond1 = params[:searchCondSel1]
    @paramsCtgrySearchCond2 = params[:searchCondSel2]
    @paramsCtgrySearchCond3 = params[:searchCondSel3]
    @srchkeyword1_sel = params[:searchCond1].to_i
    @srchkeyword2_sel = params[:searchCond2].to_i
    @srchkeyword3_sel = params[:searchCond3].to_i
    if params[:categoryAddEdit] != nil
      $categoryAddEdit = params[:categoryAddEdit]
    end

    logd('index $categoryAddEdit:', $categoryAddEdit)
    logd('@paramsCtgrySearchCond1:', @paramsCtgrySearchCond1)
    @srchkeyword1 = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname1 FROM comdties WHERE srchkeyname1 IS NOT NULL") 
    @srchkeyword2 = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname2 FROM comdties WHERE srchkeyname2 IS NOT NULL") 
    @srchkeyword3 = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname3 FROM comdties WHERE srchkeyname3 IS NOT NULL") 
    @srchkeyword1.each do |srch|
      logd('srch.srchkeyname1:', srch.srchkeyname1)
    end
    @srchkeyword2.each do |srch|
      logd('srch.srchkeyname2:', srch.srchkeyname2)
    end
    @srchkeyword3.each do |srch|
      logd('srch.srchkeyname3:', srch.srchkeyname3)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ctgrymtbls }
    end
  end

  def piyo
      logd('piyo:', "")
  end

  # GET /ctgrymtbls/1
  # GET /ctgrymtbls/1.xml
  def show
    @ctgrymtbls = Ctgrymtbl.all
    $showsw = 1
    logd("show:", "")
    logd("params[:searchCtgryName]:", params[:searchCtgryName])
    logd("params[:id]:", params[:id])
    logd("params[:categoryAddEdit]:", params[:categoryAddEdit])
    logd("params[:ctgryMode]:", params[:ctgryMode])
    logd("params[:addEdit]:", params[:addEdit])
    @srchkeyword1_sel = params[:searchCond1].to_i
    @srchkeyword2_sel = params[:searchCond2].to_i
    @srchkeyword3_sel = params[:searchCond3].to_i
    @ctgrymtbl = Ctgrymtbl.new
    if params[:id] != nil && params[:searchCtgryName] == nil
      if params[:ctgryMode] != nil && params[:categoryAddEdit] == nil
	$categoryAddEdit = "1"	#編集
      end
      @ctgrymtbl = Ctgrymtbl.find_by_id(params[:id])
      if @ctgrymtbl == nil
	@ctgrymtbl = Ctgrymtbl.find_by_ctgryname(params[:id])
      end
      if $categoryAddEdit == "1" 
	if params[:id] == "基本"
	  @parentCtgryName = ""
	  @ctgryCode = "1"
	  @ctgryName = "基本"
	  @tabDisplayName = ""
	  return
	end
	parentctgry = Ctgrymtbl.find_by_ctgrycode(@ctgrymtbl.parentctgrycode)
	if parentctgry.ctgryname == '1'
	  @parentCtgryName = "基本"
	else
	  @parentCtgryName = parentctgry.ctgryname
	end
	@ctgryCode = @ctgrymtbl.ctgrycode
	@ctgryName = @ctgrymtbl.ctgryname
	@tabDisplayName = @ctgrymtbl.abbvctgryname
	setSearchCondition(@ctgrymtbl.ctgrycode)
      else
        @parentCtgryName = params[:id] 
        @ctgryCode = ""
        @ctgryName = ""
        @tabDisplayName = ""
      end
      return
    end
    @searchCond1 = params[:searchCond1]
    @searchCond2 = params[:searchCond2]
    @searchCond3 = params[:searchCond3]
    @parentCtgryName = params[:parentCtgryName]
    @ctgryCode = params[:searchCtgryCode]
    @ctgryName = params[:searchCtgryName]
    if params[:searchCtgryName] == "" || params[:searchCtgryName] == "基本"
      logd("ヌル文字 or 基本:", "")
      @ctgrymtbl.ctgrycode = "1"
      @ctgrymtbl.ctgryname = "基本"
      @ctgrymtbl.parentctgrycode = ""
    elsif (params[:searchCtgryName] != nil && params[:searchCtgryName] != "基本") || (params[:id] != "基本")
      logd("カテゴリあり:", "")
      if params[:searchCtgryName] != nil
	@ctgrymtbl = Ctgrymtbl.find_by_ctgryname(params[:searchCtgryName])
      else
	@ctgrymtbl = Ctgrymtbl.find_by_ctgryname(params[:id])
      end
    else
      logd("基本:", "")
      @ctgrymtbl.ctgrycode = "1"
      @ctgrymtbl.ctgryname = "基本"
      @ctgrymtbl.parentctgrycode = "" 
    end
    if @ctgrymtbl != nil 
      logd("@ctgrymtbl not nil:", "")
      @parentCtgryCode = @ctgrymtbl.parentctgrycode
      if params['change_image.x'] == nil
	if @ctgrymtbl.parentctgrycode != ""
	  @parentctgry = Ctgrymtbl.find_by_ctgrycode(@parentCtgryCode)
	  @parentCtgryName = @parentctgry.ctgryname
	else
	  @parentCtgryName = ""
	end
      end
      if params[:searchCtgryCode] == ""
	@ctgryCode = @ctgrymtbl.ctgrycode
      end
      if params[:searchCtgryName] == ""
	@ctgryName = @ctgrymtbl.ctgryname
      end
      if @ctgrymtbl.parentctgrycode == "1"
	@tabDisplayName = @ctgrymtbl.ctgryname
      else
	@tabDisplayName = ""
      end
    else
      logd("@ctgrymtbl nil:", "")
      @parentCtgryName = params[:parentCtgryName]
      @ctgryCode = params[:searchCtgryCode]
      @ctgryName = params[:searchCtgryName]
      @tabDisplayName = params[:tabDisplayName]
    end
    logd("@parentCtgryCode:", @parentCtgryCode)
    logd("@parentCtgryName:", @parentCtgryName)
    if params[:categoryAddEdit] != nil
      $categoryAddEdit = params[:categoryAddEdit]
    end
    @paramsCtgrySearchCond1 = params[:searchCondSel1]
    @paramsCtgrySearchCond2 = params[:searchCondSel2]
    @paramsCtgrySearchCond3 = params[:searchCondSel3]
    logd("show $categoryAddEdit:", $categoryAddEdit)
    logd("@paramsCtgrySearchCond1:", @paramsCtgrySearchCond1)
    logd("params['confirm_image.x']:", params['confirm_image.x'])
    if params['confirm_image.x'].to_i > 1
      if $categoryAddEdit == "0"
        newctg
      else
	updatectg(0)
      end
    elsif params['change_image.x'].to_i > 1
      updatectg(1)
      $categoryAddEdit = 1 #強制的に編集モードに設定
    elsif params['del_image.x'].to_i > 1
      @ctgrymtbl.destroy
      Srchctgrymtbl.where("ctgrycode = ?", @ctgrymtbl.ctgrycode).destroy_all
    elsif params['affiliate_image.x'].to_i > 1
      $ctgryname = params[:searchCtgryName]
      $ctgrymtbl = @ctgrymtbl
      redirect_to cmdtyctgries_url
      return
    end

    index
  end

  def updatectg(change_parent)
    logd("updatectg:", "")
    logd("$ctgryCode:", $ctgryCode)
    logd("params[:searchCtgryCode]:", params[:searchCtgryCode])
    @ctgrymtbl = Ctgrymtbl.new
    parentctgrycode = ""
    if params[:parentCtgryName] != ""
      if params[:parentCtgryName] == "基本"
        parentctgrycode = "1"
      else
        parentctgry1 = Ctgrymtbl.find_by_ctgryname(params[:parentCtgryName])
        parentctgrycode = parentctgry1.ctgrycode
      end
    else
      parentctgrycode = ""
    end
    ctg =  Ctgrymtbl.find_by_ctgryname(params[:searchCtgryName])
    logd("ctg.parentctgrycode:", ctg.parentctgrycode)
    logd("parentctgrycode:", parentctgrycode)
    if ctg.parentctgrycode != parentctgrycode
      if change_parent == 0
	flash[:notice] = "親カテゴリ名が変更されています。"
	return
      end
    end
    Ctgrymtbl.where("ctgrycode = ?", params[:searchCtgryCode]).update_all(:parentctgrycode => parentctgrycode, :ctgryname => params[:searchCtgryName], :abbvctgryname => params[:tabDisplayName])

    update_srchctgrymtbl
  end

  def newctg
    logd("newctg:", "")
    @ctgrymtbl = Ctgrymtbl.new
    checkctgrcode = Ctgrymtbl.find_by_ctgrycode(params[:searchCtgryCode])
    logd("checkctgrcode:", checkctgrcode)
    flash[:notice] = ""
    if checkctgrcode != nil
      logd("checkctgrcode 重複:", "")
      flash[:notice] = "カテゴリコードが重複しています。"
      logd("flash[:notice]:", flash[:notice])
      return
    end
    checkctgrname = Ctgrymtbl.find_by_ctgryname(params[:searchCtgryName])
    if checkctgrname != nil
      logd("checkctgrname 重複:", "")
      flash[:notice] = "カテゴリ名が重複しています。"
      logd("flash[:notice]:", flash[:notice])
      return
    end
    logd("flash[:notice]:", flash[:notice])
    if params[:parentCtgryName] != "" 
      if params[:parentCtgryName] == "基本"
	@ctgrymtbl.parentctgrycode = "1"
      else
	parentctgry1 = Ctgrymtbl.find_by_ctgryname(params[:parentCtgryName])
	@ctgrymtbl.parentctgrycode = parentctgry1.ctgrycode
      end
    else
      @ctgrymtbl.parentctgrycode = ""
    end
    @ctgrymtbl.ctgrycode = params[:searchCtgryCode]
    @ctgrymtbl.ctgryname = params[:searchCtgryName] #.encode("utf-8")
    @ctgrymtbl.abbvctgryname = params[:tabDisplayName] #.encode("utf-8")
    if @ctgrymtbl.ctgrycode != ""
      @ctgrymtbl.save
      new_srchctgrymtbl(1)
      new_srchctgrymtbl(2)
      new_srchctgrymtbl(3)
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

    $htmlstr = ""
    d = ls_tree(path)
    logd('$htmlstr:', $htmlstr)
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

  def ctgryMode
    logd("ctgryModea:", "")
  end

  def update_srchctgrymtbl
    logd("params[:searchCtgryCode]:", params[:searchCtgryCode])
    Srchctgrymtbl.where("ctgrycode=?", params[:searchCtgryCode] ).delete_all
    new_srchctgrymtbl(1)
    new_srchctgrymtbl(2)
    new_srchctgrymtbl(3)
  end

  def new_srchctgrymtbl(i)
    srchctgrymtbl = Srchctgrymtbl.new
    srchctgrymtbl.ctgrycode = params[:searchCtgryCode]
    srchctgrymtbl.srchkeycode = i
    if i == 1
      if params[:searchCondSel1] == "2"
	srchkeyword = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname1 FROM comdties WHERE cmdtycode = '" + params[:searchCond1] + "'") 
	srchctgrymtbl.srchkeyname = srchkeyword.first["srchkeyname1"]
	#@srchkeyword1_selected = 
	logd("srchctgrymtbl.srchkeyname:", srchctgrymtbl.srchkeyname)
      elsif params[:searchCondSel1] == "1"
	srchctgrymtbl.srchkeyname = params[:searchCond1]
      else
	return
      end
      if params[:searchCondSel1] == nil
	srchctgrymtbl.disptype = 0
      else
	srchctgrymtbl.disptype = params[:searchCondSel1].to_i
      end
      logd("srchctgrymtbl.ctgrycode:", srchctgrymtbl.ctgrycode)
      logd("srchctgrymtbl.srchkeycode:", srchctgrymtbl.srchkeycode)
      logd("srchctgrymtbl.srchkeyname:", srchctgrymtbl.srchkeyname)
      logd("srchctgrymtbl.disptype:", srchctgrymtbl.disptype)
      srchctgrymtbl.save
    elsif i == 2
      if params[:searchCondSel2] == "2"
        srchkeyword = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname2 FROM comdties WHERE cmdtycode = '" + params[:searchCond2] + "'")
        srchctgrymtbl.srchkeyname = srchkeyword.first["srchkeyname2"]
        logd("srchctgrymtbl.srchkeyname:", srchctgrymtbl.srchkeyname)
      elsif params[:searchCondSel2] == "1"
        srchctgrymtbl.srchkeyname = params[:searchCond2]
      else
        return
      end

      if params[:searchCondSel2] == nil
	srchctgrymtbl.disptype = 0
      else
	srchctgrymtbl.disptype = params[:searchCondSel2].to_i
      end
      srchctgrymtbl.save
    elsif i == 3
      if params[:searchCondSel3] == "2"
        srchkeyword = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname3 FROM comdties WHERE cmdtycode = '" + params[:searchCond3] + "'")
        srchctgrymtbl.srchkeyname = srchkeyword.first["srchkeyname3"]
        logd("srchctgrymtbl.srchkeyname:", srchctgrymtbl.srchkeyname)
      elsif params[:searchCondSel3] == "1"
        srchctgrymtbl.srchkeyname = params[:searchCond3]
      else
        return
      end

      if params[:searchCondSel3] == nil
	srchctgrymtbl.disptype = 0
      else
	srchctgrymtbl.disptype = params[:searchCondSel3].to_i
      end
      srchctgrymtbl.save
    end
  end

  def setSearchCondition(ctgcode)
    srchctgrymtbl = Srchctgrymtbl.find_by_sql("SELECT * FROM srchctgrymtbls WHERE ctgrycode = '" + ctgcode + "'")
    logd("srchctgrymtbl.size:", srchctgrymtbl.size)
    if srchctgrymtbl.size == 0
      return
    end
    j = 1
    while j <= 3
      i = srchctgrymtbl.first["srchkeycode"] 
      logd("i:", i)
      case i
      when 1 then
	@paramsCtgrySearchCond1 = srchctgrymtbl.first["disptype"].to_s
	setCondValue(srchctgrymtbl.first, i)
      when 2 then
	@paramsCtgrySearchCond2 = srchctgrymtbl.first["disptype"].to_s
	setCondValue(srchctgrymtbl.first, i)
      when 3 then
	@paramsCtgrySearchCond3 = srchctgrymtbl.first["disptype"].to_s
	setCondValue(srchctgrymtbl.first, i)
      else
      end
      srchctgrymtbl.shift
      j += 1
    end
  end
  
  def setCondValue(hs, i)
    name = hs["srchkeyname"]
    logd("name:", name)
    case i
    when 1 then
      if hs["disptype"] == 1
	@searchCond1 = name
      elsif hs["disptype"] == 2
	@srchkeyword1 = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname1 FROM comdties WHERE srchkeyname1 IS NOT NULL") 
	srchkeyword1a = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname1 FROM comdties WHERE srchkeyname1 = '" + name + "'") 
	@srchkeyword1_sel = srchkeyword1a.first["cmdtycode"].to_i
	logd("srchkeyword1a.first[cmdtycode]:", srchkeyword1a.first["cmdtycode"])
      end
    when 2 then
      if hs["disptype"] == 1
        @searchCond2 = name
      elsif hs["disptype"] == 2
        @srchkeyword2 = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname2 FROM comdties WHERE srchkeyname2 IS NOT NULL")
	srchkeyword2a = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname2 FROM comdties WHERE srchkeyname2 = '" + name + "'") 
	@srchkeyword2_sel = srchkeyword2a.first["cmdtycode"].to_i
	logd("srchkeyword2a.first[cmdtycode]:", srchkeyword2a.first["cmdtycode"])
      end
    when 3 then
      if hs["disptype"] == 1
        @searchCond3 = name
      elsif hs["disptype"] == 2
        @srchkeyword3 = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname3 FROM comdties WHERE srchkeyname3 IS NOT NULL")
	srchkeyword3a = Comdty.find_by_sql("SELECT cmdtycode, srchkeyname3 FROM comdties WHERE srchkeyname3 = '" + name + "'") 
	@srchkeyword3_sel = srchkeyword3a.first["cmdtycode"].to_i
	logd("srchkeyword3a.first[cmdtycode]:", srchkeyword3a.first["cmdtycode"])
      end
    else
    end
    logd("@srchkeyword1_sel:", @srchkeyword1_sel)
    logd("@srchkeyword2_sel:", @srchkeyword2_sel)
    logd("@srchkeyword3_sel:", @srchkeyword3_sel)
  end
end
