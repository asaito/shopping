# -*- coding:utf-8 -*-
class MallshopmsController < ApplicationController
  # GET /mallshopms
  # GET /mallshopms.xml
  def index
    #@mallshopms = Mallshopm.all
    @malladmin = current_malladmin
    @mallshopms = Mallshopm.where("malladmin_id=?",@malladmin.id).latest
    @func = ''

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mallshopms }
    end
  end

  # GET /mallshopms/1
  # GET /mallshopms/1.xml
  def show
    @malladmin = current_malladmin
    @mallshopm = Mallshopm.find(params[:id])
    @prefecture = Prefecture.find_by_sql("select * from prefectures")
    @func = 'show'
    @onload = 'on_load()'

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mallshopm }
    end
  end

  # GET /mallshopms/new
  # GET /mallshopms/new.xml
  def new
    @malladmin = current_malladmin
    @mallshopm = Mallshopm.new
    @prefecture = Prefecture.find_by_sql("select * from prefectures")
    @func = ''
    @onload = 'window.onload()'
    @onload = 'on_load()'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mallshopm }
    end
  end

  # GET /mallshopms/1/edit
  def edit
    @malladmin = current_malladmin
    @mallshopm = Mallshopm.find(params[:id])
    $mallshopm = @mallshopm
    @prefecture = Prefecture.find_by_sql("select * from prefectures")
    @func = 'edit'
    #@onload = 'window.alert("hello")'
    #@onload = 'window.onload()'
    @onload = 'on_load()'
  end

  def reset
    @malladmin = current_malladmin
    @mallshopm = $mallshopm 
    @mallshopm.mallshopcode = "1"
    @mallshopm.mallshopflg = ""
    @mallshopm.mallshopname = ""
    @mallshopm.mallshopnamekana = ""
    @mallshopm.malladmin_id = 0
    #@mallshopm.malladminname = ""
    @mallshopm.malladminpass = ""
    #@mallshopm = Mallshopm.new
    @mallshopm.frontshopname = ""
    @mallshopm.frontshopnamekana = ""
    @mallshopm.departname = ""
    @mallshopm.postcode1 = ""
    @mallshopm.postcode2 = ""
    @mallshopm.address1 = ""
    @mallshopm.address2 = ""
    @mallshopm.address3 = ""
    @mallshopm.tel = ""
    @mallshopm.fax = ""
    @mallshopm.email = ""
    @mallshopm.chargeusername = ""
    @mallshopm.discountfromdate = ""
    @mallshopm.discounttodate = ""
    @mallshopm.discountrate = 0
    @mallshopm.instockflg = 0
    @mallshopm.amountbyadvise = 0
    @mallshopm.abbvfrontshopname = ""
    @mallshopm.daysofnew = 0
    @mallshopm.giftflg = 0
    @mallshopm.status = 1
    @mallshopm.feetaxflg = 1
    @mallshopm.deliverytaxflg = 1
    @mallshopm.rankingdispflg = 1
    @mallshopm.rankingflg = 0
    @mallshopm.rankingcount = 0
    @mallshopm.rankingdays = 0
    @mallshopm.rankingdatetime ="" 
    @mallshopm.pointenableflg = 0
    @func = 'reset'
    @onload = 'on_load()'
  end

  # POST /mallshopms
  # POST /mallshopms.xml
  def create
    @mallshopm = Mallshopm.new(params[:mallshopm])
    @malladmin = current_malladmin
    @mallshopm.malladmin_id = @malladmin.id
    @mallshopm.mallshopcode = "1"
    @mallshopm.address2 = "代田"
    @mallshopm.tel = "03-3333-4444"
    @mallshopm.email = "gs975318642@gmail.com"
    @mallshopm.chargeusername = "1"
    @prefecture = Prefecture.find_by_sql("select * from prefectures")
    @func = ''
    @onload = 'on_load()'

    respond_to do |format|
      if @mallshopm.save
        format.html { redirect_to(@mallshopm, :notice => 'Mallshopm was successfully created.') }
        format.xml  { render :xml => @mallshopm, :status => :created, :location => @mallshopm }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mallshopm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mallshopms/1
  # PUT /mallshopms/1.xml
  def update
    @malladmin = current_malladmin
    @mallshopm = Mallshopm.find(params[:id])
    @func = ''
    #@onload = 'window.alert("hello")'
    #@onload = 'window.onload()'
    @onload = 'on_load()'

    respond_to do |format|
      if @mallshopm.update_attributes(params[:mallshopm])
        format.html { redirect_to(@mallshopm, :notice => 'Mallshopm was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mallshopm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mallshopms/1
  # DELETE /mallshopms/1.xml
  def destroy
    @mallshopm = Mallshopm.find(params[:id])
    @mallshopm.destroy

    respond_to do |format|
      format.html { redirect_to(mallshopms_url) }
      format.xml  { head :ok }
    end
  end
end
