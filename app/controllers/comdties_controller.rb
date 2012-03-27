# -*- encoding: utf-8 -*-
require 'rubygems'
require 'csv'
class ComdtiesController < ApplicationController
  # GET /comdties
  # GET /comdties.xml
  def index
    @num_list = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']

    logger.debug 'outputcsv_image.x:'
    if $afterIndex != 1
      $serchwhere = ''
      $paramsSearchAdvice = '-1'
      $paramsSearchMemberDiscount = '-1'
      $paramsSearchRsrvEnable = '-1'
      $paramsSearchNoStock = '-1'
      getConditions()
    end
    if params['serch_image.x']
      logger.debug '$paramsSearchCmdtyCode:' + $paramsSearchCmdtyCode.to_s
      logger.debug '$paramsSearchAdvice:' + $paramsSearchAdvice.to_s
      logger.debug 'at index $serchwhere:' + $serchwhere.to_s
      if $afterIndex != nil
        logger.debug '$afterIndex:' + $afterIndex.to_s
      end
    elsif params['outputcsv_image.x']
      logger.debug 'outputcsv_image.x:'
    end
    $saveSuccess = 1
    @comdties = Comdty.paginate(:page => params[:page], :conditions => $serchwhere, :order => 'cmdtycode asc', :per_page => $sel_no_cm)
    logd("$sel_no_cm:", $sel_no_cm)
    cmtotal = Comdty.where($serchwhere)
    if cmtotal != nil
      @total = cmtotal.size
    else
      @total = 0
    end
    cmctgries = Cmdtyctgry.all
    @aryctg = cmctg(@comdties, cmctgries)

    cmdtystndrdms = Cmdtystndrdm.all
    @arystnd = cmstnd(@comdties, cmdtystndrdms)

    conncmdtyms = Conncmdtym.all    
    @arycncm = cncm(@comdties, conncmdtyms)

    $comdties = @comdties
    logd("$serchwhere:", $serchwhere)
    logd("@comdties.size:", @comdties.size)
    logd("@comdties.first.cmdtycode:", @comdties.first.cmdtycode)
    logd("@aryctg:", @aryctg)
    logd("@arystnd:", @arystnd)
    logd("@arycncm:", @arycncm)
    $afterIndex = 1
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comdties }
    end
  end

  def cmctg(cms, cmctgs)
    a = []
    cms.each do |cm|
      find = 0
      ctg = ""
      cmctgs.each do |cmct|
	if cm.cmdtycode == cmct.cmdtycode
	  ctg = "1"
	  find = 1
	end
	if find == 1
	  break;
	end
      end
      a.push(ctg)
    end  
    a
  end

  def cmstnd(cms, cmstnds)
    a = []
    logd("cmstnds.size:", cmstnds.size)
    cms.each do |cm|
      find = 0
      stnd = ""
      cmstnds.each do |cmst|
	#logd("cm.cmdtycode cmst.cmdtycode:", cm.cmdtycode+" "+cmst.cmdtycode)
        if cm.cmdtycode == cmst.cmdtycode
          stnd = "1"
          find = 1
        end
        if find == 1
          break;
        end
      end
      a.push(stnd)
    end
    a
  end

  def cncm(cms, cncms)
    a = []
    logd("cncms.size:", cncms.size)
    cms.each do |cm|
      find = 0
      conncm = ""
      cncms.each do |cncm|
        #logd("cm.cmdtycode cncm.cmdtycode:", cm.cmdtycode+" "+cncm.cmdtycode)
        if cm.cmdtycode == cncm.cmdtycode
          conncm = "1"
          find = 1
        end
        if find == 1
          break;
        end
      end
      a.push(conncm)
    end
    a
  end

  # GET /comdties/1
  # GET /comdties/1.xml
  def show
    @comdty = Comdty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comdty }
    end
  end

  # GET /comdties/new
  # GET /comdties/new.xml
  def new
    logger.debug 'new_some interesting information'
    @comdty = Comdty.new
    setvariables

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comdty }
    end
  end

  # GET /comdties/1/edit
  def edit
    @comdty = Comdty.find(params[:id].to_i)
    comdtyn = Comdty.new(params[:comdty])
    #@comdty = comdtyn
    setvariables
  end

  def setvariables
    @stockcode_all = getstockcodes  #["1", "2", "3", "4", "5"]
    if params[:stockcode] != nil
      @stockcode = params[:stockcode]
    else
      @stockcode = ""
    end
    @cmdtysize_all = ["LL", "L", "M", "S"]
    @cmdtysize = "M"
    @stockstatusnames, @stockstatusname, @stockstatusids, @stockstatusid = getstockstatusnames(@comdty)
    logd("@stockstatusnames:", @stockstatusnames)
    logd("@stockstatusname:", @stockstatusname)
    logd("params[:stockstatusname]:", params[:stockstatusname])
    logd("@stockstatusid:", @stockstatusid)
    @deliverytypecode_all = ["通常便", "", ""]
    @deliverytypecode = "通常便"
  end

  def getstockcodes
    cds = []
    stockms = Stockm.all
    stockms.each do |s|
      cds.push(s.stockcode)
    end
    cds
  end

  def getstockstatusnames(comdty)
    names = []
    name = ""
    ids = []
    stid = 0
    stockstatusms = Stockstatusm.all 
    stockstatusms.each do |s|
      names.push(s.stockstatusname)
      ids.push(s.id)
      if params[:stockstatusname] != nil && params[:stockstatusname] == s.stockstatusname
	stid = s.id
      end
      if s.id == comdty.stockstatuscode
	name = s.stockstatusname
      end
    end
    return names, name, ids, stid
  end

  def reset
  end

  # POST /comdties
  # POST /comdties.xml
  def create
    logger.debug 'create_some interesting information'
    
    @num_list = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']
    if params[:page] == nil
      if params[:line_no] != nil
        $sel_no_cm = params[:line_no]
      else
        $sel_no_cm = "10"
      end
    end

    if params['del_image.x'] 
      delids = []
      checked = params[:checked_items]
      checked.each{|key, value|
	logger.debug 'checked1.key:' + key
        delids.push(key)
        value.each{|key, value|
	  logger.debug 'checked2.key:' + key
	  logger.debug 'checked2.value:' + value
	}
      }
      logger.debug 'delids.length:' + delids.length.to_s
      for i in 0..delids.length - 1
        logger.debug 'delids' + '[' + i.to_s + ']:' + delids[i]
      end
      Comdty.delete(delids) 

      respond_to do |format|
	format.html { redirect_to(comdties_url) }
	format.xml  { head :ok }
      end
    elsif params['allsel_image.x']
      $checked = true
      respond_to do |format|
        format.html { redirect_to(comdties_url) }
        format.xml  { head :ok }
      end

    elsif params['allrel_image.x']
      $checked = false
      respond_to do |format|
        format.html { redirect_to(comdties_url) }
        format.xml  { head :ok }
      end
    elsif params['serch_image.x']
      getConditions()
      respond_to do |format|
        format.html { redirect_to(comdties_url) }
        format.xml  { head :ok }
      end
    elsif params['outputcsv_image.x']
      logger.debug 'csv:'
      csv
    else
      #create
      @comdty = Comdty.new(params[:comdty])

      respond_to do |format|
        if @comdty.save
	  format.html { redirect_to(@comdty, :notice => 'Comdty was successfully created.') }
	  format.xml  { render :xml => @comdty, :status => :created, :location => @comdty }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @comdty.errors, :status => :unprocessable_entity }
	end
      end
    end
  end

  def params2db
    d = Comdty.find(params[:id].to_i)
    logd("d:", d)
    logd("d.cmdtycode:", d.cmdtycode)
    logd("params[:comdty][description]:", params[:comdty]["description"])
    logd("params[:unitprice]:", params[:unitprice])
    #d.shopcode = params[:comdty[shopcope]]
    #d.cmdtycode = params[:comdty]["cmdtycode"]
    d.jancode = params[:comdty]["jancode"]
    d.cmdtyname = params[:comdty]["cmdtyname"]
    d.description = params[:comdty]["description"]
    d.stockcode = params[:stockcode]
    d.stockunitprice = params[:stockunitprice].to_i
    d.unitprice = params[:unitprice].to_i
    d.salesunitprice = params[:salesunitprice].to_i
    d.taxflg = params[:comdty]["taxflg"] == "taxincluded" ? 0 : (params[:comdty]["taxflg"] == "taxexcluded" ? 1 : 2)
    d.adviceflg = params[:comdty]["adviceflg"] == "normal" ? 0 : 1
    d.bannerfile = params[:comdty]["bannerfile"]
    d.bannerurl = params[:comdty]["bannerurl"]
    d.memberdiscountflg = params[:comdty]["memberdiscountflg"] == "no" ? 0 : 1
    d.srchkeyname1 = params[:comdty]["srchkeyname1"]
    d.srchkeyname2 = params[:comdty]["srchkeyname2"]
    d.srchkeyname3 = params[:comdty]["srchkeyname3"]
    d.cmdtysize = params[:cmdtysize]
    #d.sellfromdate = params[:comdty]["sellfromdate"]
    #logd("params[:comdty][sellfromdate(1i)]:", params[:comdty]["sellfromdate(1i)"])
    d.sellfromdate = Date.new(params[:comdty]["sellfromdate(1i)"].to_i, params[:comdty]["sellfromdate(2i)"].to_i, params[:comdty]["sellfromdate(3i)"].to_i)
    #d.endsellflg = params[:comdty[endsellflg]]
    d.selltodate = Date.new(params[:comdty]["selltodate(1i)"].to_i, params[:comdty]["selltodate(2i)"].to_i, params[:comdty]["selltodate(3i)"].to_i)
    d.salesfromdate = Date.new(params[:comdty]["salesfromdate(1i)"].to_i, params[:comdty]["salesfromdate(2i)"].to_i, params[:comdty]["salesfromdate(3i)"].to_i)
    d.salestodate = params[:comdty]["salestodate"]
    d.salestodate = Date.new(params[:comdty]["salestodate(1i)"].to_i, params[:comdty]["salestodate(2i)"].to_i, params[:comdty]["salestodate(3i)"].to_i)
    d.rsrvenableflg = params[:comdty]["rsrvenableflg"] == "no" ? 0 : 1
    d.nostockflg = params[:comdty]["nostockflg"] == "no" ? 0 : 1
    d.amount = params[:amount].to_i
    d.stockstatuscode = params[:stockstatuscode]
    d.wrappingflg = params[:comdty]["wrappingflg"] == "no" ? 0 : 1
    d.deliverytypecode = params[:deliverytypecode].to_i
    d.amountflg = params[:comdty]["amountflg"] == "no" ? 0 : 1
    d.rsrvamount = params[:rsrvamount].to_i
    #d.ranking = params[:comdty[ranking]]
    d.rankingdatetime = params[:comdty]["rankingdatetime"]
    d.initdatetime = params[:comdty]["initdatetime"]
    d
  end

  # PUT /comdties/1
  # PUT /comdties/1.xml
  def update
    #@bodyFlash = 0
    $saveSuccess = 1
    #@comdty = Comdty.find(params[:id].to_i)
    @comdty = params2db
    @stockstatusid = Stockstatusm.find_by_stockstatusname(params[:stockstatusname]).id.to_s
      @comdty.stockstatuscode = @stockstatusid
    logd("params[:stockstatusname]:", params[:stockstatusname])
    logd("@stockstatusid:", @stockstatusid)
    logd("params[:id]:", params[:id])

    logger.debug 'update_some interesting information'
    logd("params[:stockstatusname]:", params[:stockstatusname])
    logd("@stockstatusid:", @stockstatusid)
    #logger.debug '$copy:' + $copy
    #logd("$copy:", $copy)
    #logger.debug '$cmdtycode:' + $cmdtycode
    #logger.debug '@comdty.cmdtycode:' + @comdty.cmdtycode
    respond_to do |format|
      if $copy == '1'
	#@comdty.id = $idcmd
	#logger.debug '@comdty.id:' + @comdty.id.to_s 
        urlstr = "?copy=1&cmdtycode=" + @comdty.cmdtycode + "&idcmd=" + $idcmd.to_s
	logger.debug 'urlstr:' + urlstr
	if Comdty.find_by_cmdtycode(@comdty.cmdtycode)
	  #@bodyFlash = 1
	  $saveSuccess = 0
	  logger.debug 'come to fail'
	  @comdty.id = $idcmd
	  format.html { redirect_to(edit_comdty_path(@comdty) + urlstr, :notice => '登録に失敗しました。商品コードを変更して下さい！') }
	else
	  logger.debug 'come to success at copy'
          if @comdty.save
	    $saveSuccess = 1
	    #@bodyFlash = 1
	    format.html { redirect_to(edit_comdty_path(@comdty) + urlstr, :notice => 'comdty was successfully created.')}
            format.xml  { render :xml => @comdty, :status => :created, :location => @comdty }
	  else
            format.html { render :action => "new" }
	    format.xml  { render :xml => @comdty.errors, :status => :unprocessable_entity }
          end
	end
      else
	logger.debug 'come to success'
	#logger.debug '@comdty.id:' + @comdty.id.to_s
	#logger.debug '$idcmd:' + $idcmd
	#@comdty.id = $idcmd.to_i
	#@comdty.id = ''
	#if @comdty.update_attributes(params[:comdty])
	if @comdty.save
	  #@bodyFlash = 0
          format.html { redirect_to(@comdty, :notice => 'Comdty was successfully updated.') }
          format.xml  { head :ok }
        else
	  format.html { render :action => "edit" }
	  format.xml  { render :xml => @comdty.errors, :status => :unprocessable_entity }
	end
      end
    end
  end

  # DELETE /comdties/1
  # DELETE /comdties/1.xml
  def destroy
    logger.debug 'destroy_some interesting information'
    @comdty = Comdty.find(params[:id])
    @comdty.destroy

    respond_to do |format|
      format.html { redirect_to(comdties_url) }
      format.xml  { head :ok }
    end
  end

  def getConditions
        logger.debug 'at getConditions:'
	if params[:searchCmdtyCode] != nil
	  logger.debug 'params[:searchCmdtyCode].strip.length:' + params[:searchCmdtyCode].strip.length.to_s
	end
        $serchwhere = ''
	preceed = ''
        if params[:searchCmdtyCode] != nil 
	  $paramsSearchCmdtyCode = params[:searchCmdtyCode]
	  if params[:searchCmdtyCode].strip.length != 0
	    $serchwhere += 'cmdtycode like ' + "\'%" + params[:searchCmdtyCode] + "%\'"
	    preceed = ' AND '
	  end
        end
        if params[:searchCmdtyName] != nil 
	  $paramsSearchCmdtyName = params[:searchCmdtyName]
	  if params[:searchCmdtyName].strip.length != 0
	    $serchwhere += preceed + 'cmdtyname like ' + "\'%" + params[:searchCmdtyName] + "%\'"
	    preceed = ' AND '
	  end
        end
        if params[:searchCmdtyStockCount1] != nil 
	  $paramsSearchCmdtyStockCount1 = params[:searchCmdtyStockCount1]
	  if params[:searchCmdtyStockCount1].strip.length != 0
	    $serchwhere += preceed + 'amount >= ' + params[:searchCmdtyStockCount1].to_s
	    preceed = ' AND '
	  end
        end
        if params[:searchCmdtyStockCount2] != nil 
	  $paramsSearchCmdtyStockCount2 = params[:searchCmdtyStockCount2]
	  if params[:searchCmdtyStockCount2].strip.length != 0
	    $serchwhere +=  preceed + 'amount <= ' + params[:searchCmdtyStockCount2].to_s
	    preceed = ' AND '
	  end
        end
        if params[:searchAdvice] != nil 
	  $paramsSearchAdvice = params[:searchAdvice]
	  if params[:searchAdvice] != '-1'
	    $serchwhere += preceed + 'adviceflg = ' + params[:searchAdvice].to_s
	    preceed = ' AND '
	  end
	end
        if params[:searchMemberDiscount] != nil 
	  $paramsSearchMemberDiscount = params[:searchMemberDiscount]
	  if params[:searchMemberDiscount] != '-1'
	    $serchwhere += preceed + 'memberdiscountflg = ' + params[:searchMemberDiscount].to_s
	    preceed = ' AND '
	  end
	end
        if params[:searchRsrvEnable] != nil 
	  $paramsSearchRsrvEnable = params[:searchRsrvEnable]
	  if params[:searchRsrvEnable] != '-1'
	    $serchwhere += preceed + 'rsrvenableflg = ' + params[:searchRsrvEnable].to_s
	    preceed = ' AND '
	  end
	end
        if params[:searchNoStock] != nil 
	  $paramsSearchNoStock = params[:searchNoStock]
	  if params[:searchNoStock] != '-1'
	    $serchwhere += preceed + 'nostockflg = ' + params[:searchNoStock].to_s
	  end
	end
        logger.debug 'at getConditions $serchwhere:' + $serchwhere
        logger.debug '$paramsSearchCmdtyCode:' + $paramsSearchCmdtyCode.to_s
  end

  def csv
    filename = "comdties#{Time.now.strftime('%Y_%m_%d_%H_%M_%S')}.csv"
    filepath = "tmp/csv/" + filename
    output = CSV.open(filepath, "a") do |csv|
#    output = CSV.generate(filepath, "a") do |csv|
      csv << ['ID', 'ショップコード', '商品コード', 'ＪＡＮコード', '商品名', '商品説明', '仕入先コード', '仕入価格', '本体価格', '特別価格', '本体価格税区分', 'おすすめフラグ', '商品バナーファイル', 'リンク先アドレス', '会員値引フラグ', '検索キーワード1', '検索キーワード2', '検索キーワード3', '商品サイズ', '販売開始日', '販売終了日設定フラグ', '販売終了日', '特別価格開始日', '特別価格終了日', '予約販売フラグ', '予約可能数', '在庫無販売フラグ', '在庫数量', '在庫数管理フラグ', '在庫状況番号', 'ラッピングフラグ', '配送種別コード', 'ランキング順位', 'ランキング集計日時', '登録日時', '更新日時']
    #output = CSV.open(filepath, "a") do |csv|
      $comdties.each do |comdty|
	csv << [comdty.id, comdty.shopcode, comdty.cmdtycode, comdty.jancode, comdty.cmdtyname, comdty.description, comdty.stockcode, comdty.stockunitprice, comdty.unitprice, comdty.salesunitprice, comdty.taxflg, comdty.adviceflg, comdty.bannerfile, comdty.bannerurl, comdty.memberdiscountflg, comdty.srchkeyname1, comdty.srchkeyname2, comdty.srchkeyname3, comdty.cmdtysize, comdty.sellfromdate, comdty.endsellflg, comdty.selltodate, comdty.salesfromdate, comdty.salestodate, comdty.rsrvenableflg, comdty.nostockflg, comdty.amount, comdty.stockstatuscode, comdty.wrappingflg, comdty.deliverytypecode, comdty.amountflg, comdty.rsrvamount, comdty.ranking, comdty.rankingdatetime, comdty.initdatetime, comdty.updated_at]
      end
    end
    send_file(filepath,
              :type => 'text/csv',
    	      :filename => filename)
  end

end
