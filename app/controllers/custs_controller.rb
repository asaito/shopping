class CustsController < ApplicationController
  # GET /custs
  # GET /custs.xml
  def index
    @num_list = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']

    $memberlevel_list = ["1", "2", "3"]
    #@sel_memberlevel = "2"

    logd("$serchwhere:", $serchwhere)
    logd("@id_serch:", @id_serch)
    @custs = Cust.paginate(:page => params[:page], :conditions => $serchwhere, :order => 'id asc', :per_page => $sel_no_cm)
    cmtotal = Cust.where($serchwhere)
    if cmtotal != nil
      @total = cmtotal.size
    else
      @total = 0
    end

=begin
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @custs }
    end
=end
  end

  def getConditions
    if params[:id_serch] != nil
      logger.debug 'params[:id_serch].strip.length:' + params[:id_serch].strip.length.to_s
    end
    serchwhere = ''
    preceed = ''
    if params[:id_serch] != nil
      $id_serch = params[:id_serch]
      if params[:id_serch].strip.length != 0
        serchwhere += 'id = ' + params[:id_serch]
        preceed = ' AND '
      end
    end
    if params[:custname_serch] != nil
      $custname_serch = params[:custname_serch]
      if params[:custname_serch].strip.length != 0
        serchwhere += preceed + 'custname like ' + "\'%" + params[:custname_serch] + "%\'"
        preceed = ' AND '
      end
    end
    if params[:memberlevel_serch] != nil
      $sel_memberlevel = params[:memberlevel_serch]
      if params[:memberlevel_serch].strip.length != 0
        serchwhere += preceed + 'memberlevelcode = ' + "'" + params[:memberlevel_serch] + "'"
        preceed = ' AND '
      end
    end
    if params[:custpronname_serch] != nil
      $custpronname_serch = params[:custpronname_serch]
      if params[:custpronname_serch].strip.length != 0
        serchwhere += preceed + 'custpronname like ' + "\'%" + params[:custpronname_serch] + "%\'"
        preceed = ' AND '
      end
    end
    if params[:custcompanyflg_serch] != nil
      $custcompanyflg_serch = params[:custcompanyflg_serch]
      if params[:custcompanyflg_serch].strip.length != 0
	if params[:custcompanyflg_serch] != "both"
	  serchwhere += preceed + 'custcompanyflg = ' + "'" + params[:custcompanyflg_serch] + "'"
	end
        preceed = ' AND '
      end
    end
    if params[:email_serch] != nil
      $email_serch = params[:email_serch]
      if params[:email_serch].strip.length != 0
        serchwhere += preceed + 'email like ' + "\'%" + params[:email_serch] + "%\'"
        preceed = ' AND '
      end
    end
    if params[:newmailflg_serch] != nil
      $newmailflg_serch = params[:newmailflg_serch]
      if params[:newmailflg_serch].strip.length != 0
	if params[:newmailflg_serch] != "both"
	  serchwhere += preceed + 'newmailflg = ' + "'" + params[:newmailflg_serch] + "'"
	end
        preceed = ' AND '
      end
    end
    serchwhere
  end

  # GET /custs/1
  # GET /custs/1.xml
  def show
    @cust = Cust.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cust }
    end
  end

  # GET /custs/new
  # GET /custs/new.xml
  def new
    @cust = Cust.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cust }
    end
  end

  # GET /custs/1/edit
  def edit
    @cust = Cust.find(params[:id])
  end

  # POST /custs
  # POST /custs.xml
  def create
    if params[:page] == nil
      if params[:line_no] != nil
        $sel_no_cm = params[:line_no]
      else
        $sel_no_cm = "10"
      end
    end
    if params['serch_image.x'].to_i > 0
      logd("$custcompanyflg_serch:", $custcompanyflg_serch)
      $serchwhere = getConditions()
      logd("$serchwhere:", $serchwhere)
    elsif params['outputcsv_image.x']
    elsif params['sendnewmail_image.x']
    else
      @cust = Cust.new(params[:cust])
      respond_to do |format|
	if @cust.save
	  format.html { redirect_to(@cust, :notice => 'Cust was successfully created.') }
	  format.xml  { render :xml => @cust, :status => :created, :location => @cust }
	else
	  format.html { render :action => "new" }
	  format.xml  { render :xml => @cust.errors, :status => :unprocessable_entity }
	end
      end
      return
    end
    respond_to do |format|
      format.html { redirect_to(custs_url) }
      format.xml  { head :ok }
    end
    return

=begin
    @cust = Cust.new(params[:cust])
    respond_to do |format|
      if @cust.save
        format.html { redirect_to(@cust, :notice => 'Cust was successfully created.') }
        format.xml  { render :xml => @cust, :status => :created, :location => @cust }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cust.errors, :status => :unprocessable_entity }
      end
    end
=end
  end

  # PUT /custs/1
  # PUT /custs/1.xml
  def update
    @cust = Cust.find(params[:id])

    respond_to do |format|
      if @cust.update_attributes(params[:cust])
        format.html { redirect_to(@cust, :notice => 'Cust was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cust.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /custs/1
  # DELETE /custs/1.xml
  def destroy
    @cust = Cust.find(params[:id])
    @cust.destroy

    respond_to do |format|
      format.html { redirect_to(custs_url) }
      format.xml  { head :ok }
    end
  end
end
