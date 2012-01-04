class CtgrymtblsController < ApplicationController
  # GET /ctgrymtbls
  # GET /ctgrymtbls.xml
  def index
    @ctgrymtbls = Ctgrymtbl.all

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
    path = "./"
    path = params["root"] unless root_flg
    arry = []
    d = ctg_list(path, arry)
    render :json => arry || [], :layout => false
  end

protected
  def ctg_list(path, arry=[], root_flg=false)
    logger.debug 'path:' + path
    @ctgrylists = Ctgrylist.find_by_sql(["select * from ctg_paths order by ctgryname, path;"])
    @ctgrylistssort = Ctgrylist.new
    ary = Array.new
    #sortary = []
    name_ary = Array.new
    #sortname_ary = []
    i = 0
    first = 1
    @ctgrylists.each do |ctg|
      if first == 1
	first = 0
      else
	logd('              ', ctg.ctgryname)
        logd('path:', ctg.path) 
        ary[i] = ctg.path.split(/\//)
        name_ary[i] = ctg.ctgryname
	logd('name_ary:', name_ary[i]) 
	i += 1
      end
    end
    sortctg(ary, name_ary, i)

    #treelist(path, arry)
    treelist1(path, arry)
    arry
  end
  
protected
  def sortctg(ary, name_ary, i)
    logd('i:', i.to_s)
    logary('name_ary:', name_ary) 
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
    
    arys = Array.new()
    for j in 0..i - 1
      arys[j] = 0
    end
    logd("arys.size:", arys.size)
    
    seq = 0
    cur = 0
    ctg_ary = Array.new
    cont = Array.new()
    tree = Tree.new
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
      logcont(t)
      tree << t
    end
    logcont(ctg_ary)
    logcont(name_ary)
    logd('tree:', '')
    logd('', tree)

    logd('name tree:', '')
    logd('', tree.to_s1(3, fmt = "%s+- %s\n", ctg_ary, name_ary))
  end

  def logcont(cont)
    str = ''
    i = 0
    logd('cont.size:', cont.size.to_s)
    while i < cont.size
      str += cont[i].to_s + ' '
      i += 1
    end
    logd('str:', str)
  end

protected
  def treelist(path, arry)
    @ctgrylists.each do |ctg|
      h = {"id" => d, "text" => File.basename(d), "path" => File.dirname(d), "expanded" => false, "classes" => classes, "hasChildren" => hasChildren, "children" => []}
      arry << h
    end
  end
protected
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
    render :json => arry || [], :layout => false
  end
 
protected
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

  def treelist
      h = {"id" => d, "text" => File.basename(d), "path" => File.dirname(d), "expanded" => false, "classes" => classes, "hasChildren" => hasChildren, "children" => []}
      arry << h
  end
end
