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
    logd("params[:searchCond1]:", params[:searchCond1])
    logd("params[:searchCond2]:", params[:searchCond2])
    logd("params[:searchCond3]:", params[:searchCond3])
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
      $ctgrymtbl_changed = 1
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
	$ctgrymtbl_changed = 1
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
