class ComdtymsController < ApplicationController
  # GET /comdtyms
  # GET /comdtyms.xml
  def index
    @comdtyms = Comdtym.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comdtyms }
    end
  end

  # GET /comdtyms/1
  # GET /comdtyms/1.xml
  def show
    @comdtym = Comdtym.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comdtym }
    end
  end

  # GET /comdtyms/new
  # GET /comdtyms/new.xml
  def new
    @comdtym = Comdtym.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comdtym }
    end
  end

  # GET /comdtyms/1/edit
  def edit
    @comdtym = Comdtym.find(params[:id])
  end

  # POST /comdtyms
  # POST /comdtyms.xml
  def create
    @comdtym = Comdtym.new(params[:comdtym])

    respond_to do |format|
      if @comdtym.save
        format.html { redirect_to(@comdtym, :notice => 'Comdtym was successfully created.') }
        format.xml  { render :xml => @comdtym, :status => :created, :location => @comdtym }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comdtym.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comdtyms/1
  # PUT /comdtyms/1.xml
  def update
    @comdtym = Comdtym.find(params[:id])

    respond_to do |format|
      if @comdtym.update_attributes(params[:comdtym])
        format.html { redirect_to(@comdtym, :notice => 'Comdtym was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comdtym.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comdtyms/1
  # DELETE /comdtyms/1.xml
  def destroy
    @comdtym = Comdtym.find(params[:id])
    @comdtym.destroy

    respond_to do |format|
      format.html { redirect_to(comdtyms_url) }
      format.xml  { head :ok }
    end
  end
end
