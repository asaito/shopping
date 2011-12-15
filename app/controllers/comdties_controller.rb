# -*- encoding: utf-8 -*-
class ComdtiesController < ApplicationController
  # GET /comdties
  # GET /comdties.xml
  def index
    #@comdties = Comdty.all
    logger.debug '$checked:' + $checked.to_s
    $saveSuccess = 1
    @comdties = Comdty.paginate(:page => params[:page], :order => 'cmdtycode asc', :per_page => 10)

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

  def plural_destroy
    #items = params[:checked_items].keys
    items = params[:checked_items][1]
    Comdty.destroy(items)
    redirect_to :action => 'index'
  end

end
