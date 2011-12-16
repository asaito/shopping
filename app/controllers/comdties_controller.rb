# -*- encoding: utf-8 -*-
class ComdtiesController < ApplicationController
  # GET /comdties
  # GET /comdties.xml
  def index
    #@comdties = Comdty.all
    if $afterIndex != 1
      $serchwhere = ''
      $paramsSearchAdvice = '-1'
      $paramsSearchMemberDiscount = '-1'
      $paramsSearchRsrvEnable = '-1'
      $paramsSearchNoStock = '-1'
      getConditions()
    end
    logger.debug '$paramsSearchCmdtyCode:' + $paramsSearchCmdtyCode.to_s
    logger.debug '$paramsSearchAdvice:' + $paramsSearchAdvice.to_s
    logger.debug 'at index $serchwhere:' + $serchwhere
    if $afterIndex != nil
      logger.debug '$afterIndex:' + $afterIndex.to_s
    end
    #$serchwhere = ''
    $saveSuccess = 1
    @comdties = Comdty.paginate(:page => params[:page], :conditions => $serchwhere, :order => 'cmdtycode asc', :per_page => 10)
    $afterIndex = 1
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comdties }
    end
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comdty }
    end
  end

  # GET /comdties/1/edit
  def edit
    @comdty = Comdty.find(params[:id])
  end

  # POST /comdties
  # POST /comdties.xml
  def create
    logger.debug 'create_some interesting information'
    #logger.debug 'commit:' + params['del_image.x']
    #$serch = '0'
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
      #if request.query_parameters['serch']
	#$serch = request.query_parameters['serch']
      getConditions()
      respond_to do |format|
        format.html { redirect_to(comdties_url) }
        format.xml  { head :ok }
      end
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

  # PUT /comdties/1
  # PUT /comdties/1.xml
  def update
    #@bodyFlash = 0
    $saveSuccess = 1
    if $copy == '1'
      @comdty = Comdty.new(params[:comdty])
    else
      @comdty = Comdty.find(params[:id])
    end
    logger.debug 'update_some interesting information'
    logger.debug '$copy:' + $copy
    logger.debug '$cmdtycode:' + $cmdtycode
    logger.debug '@comdty.cmdtycode:' + @comdty.cmdtycode
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
	if @comdty.update_attributes(params[:comdty])
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
        if params[:searchCmdtyCode] != nil && params[:searchCmdtyCode].strip.length != 0
          $serchwhere += 'cmdtycode like ' + "\'%" + params[:searchCmdtyCode] + "%\'"
	  $paramsSearchCmdtyCode = params[:searchCmdtyCode]
	  preceed = ' AND '
        end
        if params[:searchCmdtyName] != nil && params[:searchCmdtyName].strip.length != 0
	  $serchwhere += preceed + 'cmdtyname like ' + "\'%" + params[:searchCmdtyName] + "%\'"
	  $paramsSearchCmdtyName = params[:searchCmdtyName]
	  preceed = ' AND '
        end
        if params[:searchCmdtyStockCount1] != nil && params[:searchCmdtyStockCount1].strip.length != 0
	  $serchwhere += preceed + 'amount >= ' + params[:searchCmdtyStockCount1].to_s
	  $paramsSearchCmdtyStockCount1 = params[:searchCmdtyStockCount1]
        end
        if params[:searchCmdtyStockCount2] != nil && params[:searchCmdtyStockCount2].strip.length != 0
          $serchwhere +=  preceed + 'amount <= ' + params[:searchCmdtyStockCount2].to_s
	  $paramsSearchCmdtyStockCount2 = params[:searchCmdtyStockCount2]
	  preceed = ' AND '
        end
        if params[:searchAdvice] != nil && params[:searchAdvice] != '0' && params[:searchAdvice] != '-1'
	  $serchwhere += preceed + 'adviceflg = ' + params[:searchAdvice].to_s
	  $paramsSearchAdvice = params[:searchAdvice]
	  preceed = ' AND '
	end
        if params[:searchMemberDiscount] != nil && params[:searchMemberDiscount] != '0' && params[:searchMemberDiscount] != '-1'
	  $serchwhere += preceed + 'memberdiscountflg = ' + params[:searchMemberDiscount].to_s
	  $paramsSearchMemberDiscount = params[:searchMemberDiscount]
	  preceed = ' AND '
	end
        if params[:searchRsrvEnable] != nil && params[:searchRsrvEnable] != '0' && params[:searchRsrvEnable] != '-1'
	  $serchwhere += preceed + 'rsrvenableflg = ' + params[:searchRsrvEnable].to_s
	  $paramsSearchRsrvEnable = params[:searchRsrvEnable]
	  preceed = ' AND '
	end
        if params[:searchNoStock] != nil && params[:searchNoStock] != '0' && params[:searchNoStock] != '-1'
	  $serchwhere += preceed + 'nostockflg = ' + params[:searchNoStock].to_s
	  $paramsSearchNoStock = params[:searchNoStock]
	end
        logger.debug 'at getConditions $serchwhere:' + $serchwhere
        logger.debug '$paramsSearchCmdtyCode:' + $paramsSearchCmdtyCode.to_s
  end

end
