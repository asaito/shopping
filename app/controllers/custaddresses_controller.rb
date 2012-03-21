# -*- encoding: utf-8 -*-
class CustaddressesController < ApplicationController
  # GET /custaddresses
  # GET /custaddresses.xml
  def index
    if params['back_image.x']
      redirect_to :controller => 'custs', :action => 'edit', :id => $custid
      return
    elsif params['new_image.x']
      new
      #redirect_to new_custaddress_path
      return
    end

    @custaddresses = Custaddress.all
    $cust = Cust.find(params[:id])
    $custtel = $cust.tel
    $custid = $cust.id

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @custaddresses }
    end
  end

  # GET /custaddresses/1
  # GET /custaddresses/1.xml
  def show
    @custaddress = Custaddress.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @custaddress }
    end
  end

  # GET /custaddresses/new
  # GET /custaddresses/new.xml
  def new
    @custaddress = Custaddress.new
    @custaddress.custid = $custid
    @prefectures = Prefecture.find_by_sql("select id, name from prefectures")
    logd("$custtel:", $custtel)
    logd("$custid:", $custid)
    #logd("@prefectures:", @prefectures)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @custaddress }
    end
  end

  # GET /custaddresses/1/edit
  def edit
    @custaddress = Custaddress.find(params[:id])
    @prefectures = Prefecture.find_by_sql("select id, name from prefectures")
  end

  # POST /custaddresses
  # POST /custaddresses.xml
  def create
    @custaddress = Custaddress.new(params[:custaddress])
    @custaddress.custid = $custid
    @prefectures = Prefecture.find_by_sql("select id, name from prefectures")
    logd("$custtel:", $custtel)
    logd("$custid:", $custid)
    
    if params['close_image.x']
      redirect_to :controller => 'custaddresses', :action => 'index', :id => $custid
      return
    elsif params['back_image.x']
      redirect_to :controller => 'custs', :action => 'edit', :id => $custid
      return
    elsif params['confirm_image.x']
      respond_to do |format|
	if @custaddress.save
	  format.html { redirect_to(@custaddress, :notice => 'Custaddress was successfully created.') }
	  format.xml  { render :xml => @custaddress, :status => :created, :location => @custaddress }
	else
	  format.html { render :action => "new" }
	  format.xml  { render :xml => @custaddress.errors, :status => :unprocessable_entity }
	end
      end
    end
  end

  # PUT /custaddresses/1
  # PUT /custaddresses/1.xml
  def update
    @custaddresses = Custaddress.all
    @custaddress = Custaddress.find(params[:id])
    if params['close_image.x']
      logd("come to close_image.x:", "")
      logd("$custid:", $custid)
      redirect_to :controller => 'custaddresses', :action => 'index', :id => $custid
      return
    elsif params['back_image.x']
      redirect_to :controller => 'custs', :action => 'edit', :id => $custid
      return
    elsif params['confirm_image.x']
      respond_to do |format|
	if @custaddress.update_attributes(params[:custaddress])
	  format.html { redirect_to(@custaddress, :notice => 'Custaddress was successfully updated.') }
	  format.xml  { head :ok }
	else
	  format.html { render :action => "edit" }
	  format.xml  { render :xml => @custaddress.errors, :status => :unprocessable_entity }
	end
      end
    end
  end

  # DELETE /custaddresses/1
  # DELETE /custaddresses/1.xml
  def destroy
    @custaddress = Custaddress.find(params[:id])
    @custaddress.destroy

    respond_to do |format|
      format.html { redirect_to(custaddresses_url) }
      format.xml  { head :ok }
    end
  end
end
