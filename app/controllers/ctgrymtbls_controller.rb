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
    cont = Array.new()
    for k in 1..pathsize
      subseq = 0
      elder = 0
      for j in 0 .. i - 1
	if ary[j][0] == 0 && ary[j][k] != nil && ary[j][k + 1] == nil
	  logd("mn j k ary[][]:", j.to_s+' '+k.to_s+' '+ary[j][k].to_s+' '+to_s_nil(ary[j][k-1]))
	  logd('sr ary[j][k]:', ary[j][k])
	  if k == 1
	    cont << ary[j][k]
	    logcont(cont)
	  else
	    insertAry(cont, ary[j][k], ary[j][k - 1], elder)
	    if k > 1
	      #cntAncestor(ary[j][k])	      
	      arys[j] += 1
	    end
	    logcont(cont)
	  end
	  ary[j][0] = 1
	end
	if elder != ary[j][k]
	  elder = ary[j][k]
	end
      end
    end
    logcont(cont)
    #cntCh(ary, arys, cont, pathsize)
  end

  def cntCh(ary, arys, cont, pathsize)
    i = 0
    while i < cont.size
      youger = serch(ary, cont[i], pathsize)
      j = i
      while j > i && j < cont.size
	if youger == cont[j]
	  arys[j] = j - i
	end
	j += 1
      end
      i += 1
    end        
  end
  def serch(ary, ctgcd, pathsize)
    for k in 1..pathsize
      elder = 0
      l = 8
      for j in 0 .. l - 1
        if ary[j][k] != nil && ary[j][k + 1] == nil
          logd("mn j k ary[][]:", j.to_s+' '+k.to_s+' '+ary[j][k].to_s+' '+to_s_nil(ary[j][k-1]))
          logd('sr ary[j][k]:', ary[j][k])
	  if ary[j][k] == ctgcd
	  end
        end
        if elder != ary[j][k]
          elder = ary[j][k]
        end
      end
    end
  end
  
  def insertAry(cont, ctgcd, parcd, elder)
    logd('elder:', elder)
    i = 0
    while i < cont.size
      if cont[i] == parcd
	j = i + 1
	while j < cont.size 
	  if cont[j] == elder
	    cont[j + 1, 0] = [ctgcd]
	    return
	  end
	  j += 1
	end
	cont[i + 1, 0] = [ctgcd]
	return 
      end
      i += 1
    end
    cont << ctgcd
  end
  def logcont(cont)
    str = ''
    i = 0
    logd('cont.size:', cont.size.to_s)
    while i < cont.size
      str += cont[i] + ' '
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
