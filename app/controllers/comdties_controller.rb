# -*- encoding: utf-8 -*-
class ComdtiesController < ApplicationController
  # GET /comdties
  # GET /comdties.xml
  def index
    #@comdties = Comdty.all
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

  # PUT /comdties/1
  # PUT /comdties/1.xml
  def update
    @comdty = Comdty.find(params[:id])
    logger.debug "something interesting information"
    logger.debug '$copy:' + $copy
    logger.debug '$cmdtycode:' + $cmdtycode
    logger.debug '@comdty.cmdtycode:' + @comdty.cmdtycode
    respond_to do |format|
      if ($copy == '1') && (@comdty.cmdtycode == $cmdtycode)
	logger.debug 'come to fail'
        format.html { redirect_to(@comdty, :notice => '登録に失敗しました。商品コードを変更して下さい！') }
      else
	logger.debug 'come to success'
	if @comdty.update_attributes(params[:comdty])
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
    @comdty = Comdty.find(params[:id])
    @comdty.destroy

    respond_to do |format|
      format.html { redirect_to(comdties_url) }
      format.xml  { head :ok }
    end
  end
end
