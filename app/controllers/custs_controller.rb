# -*- encoding: utf-8 -*-
require 'rubygems'
require 'csv'
class CustsController < ApplicationController
  # GET /custs
  # GET /custs.xml
  def index
    @num_list = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']
    if params[:page] == nil
      if params[:line_no] != nil
        $sel_no_cm = params[:line_no]
      else
        $sel_no_cm = "10"
      end
    end

    $memberlevel_list = ["1", "2", "3"]
    #@sel_memberlevel = "2"

    logd("$serchwhere:", $serchwhere)
    logd("@id_serch:", @id_serch)
    @custs = Cust.paginate(:page => params[:page], :conditions => $serchwhere, :order => 'id asc', :per_page => $sel_no_cm)
    $custs = @custs
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
    @prefectures = Prefecture.find_by_sql("select id, name from prefectures")
    @memberlevelms = Memberlevelm.all
    @paymethodms = Paymethodm.all
    @custattrms_job = Custattrm.find_by_sql("select * from custattrms where attrflag = '" + 0.to_s + "' order by disporder")
    @custattrms_hobby = Custattrm.find_by_sql("select * from custattrms where attrflag = '" + 2.to_s + "' order by disporder")
    @custattrms_howtoknow = Custattrm.find_by_sql("select * from custattrms where attrflag = '" + 1.to_s + "' order by disporder")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cust }
    end
  end

  # GET /custs/1/edit
  def edit
    @cust = Cust.find(params[:id])
    @prefectures = Prefecture.find_by_sql("select id, name from prefectures")
    @memberlevelms = Memberlevelm.all
    @paymethodms = Paymethodm.all
    logd("@prefectures:", @prefectures)
    @custattrms_job = Custattrm.find_by_sql("select * from custattrms where attrflag = '" + 0.to_s + "' order by disporder")
    @custattrms_hobby = Custattrm.find_by_sql("select * from custattrms where attrflag = '" + 2.to_s + "' order by disporder")
    @custattrms_howtoknow = Custattrm.find_by_sql("select * from custattrms where attrflag = '" + 1.to_s + "' order by disporder")

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
      csv
      return
    elsif params['sendnewmail_image.x']
      sendmail
    elsif params['dm_image.x']
      dm
    elsif params['del_image.x']
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
      Cust.delete(delids)

      respond_to do |format|
        format.html { redirect_to(custs_url) }
        format.xml  { head :ok }
      end
      return
    elsif params['allsel_image.x']
      $checked = true
      respond_to do |format|
        format.html { redirect_to(custs_url) }
        format.xml  { head :ok }
      end
      return
    elsif params['allrel_image.x']
      $checked = false
      respond_to do |format|
        format.html { redirect_to(custs_url) }
        format.xml  { head :ok }
      end
      return
    else
      @cust = Cust.new(params[:cust])
      logd("@params[:cust[address1]]:", params[:cust][:address1])
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
  end

  # PUT /custs/1
  # PUT /custs/1.xml
  def update
    if params['address_image.x']
      redirect_to :controller => 'custaddresses', :action => 'index', :id => params["id"]
      return
    end
    @cust = Cust.find(params[:id])
    logd("params[:cust][:address1]]:", params[:cust][:address1])

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

  def csv
    filename = "custs#{Time.now.strftime('%Y_%m_%d_%H_%M_%S')}.csv"
    filepath = "tmp/csv/" + filename
    output = CSV.open(filepath, "a") do |csv|
      csv << ['顧客ID', '個人・法人区分', '会員種別', '顧客名', '顧客名カナ', 'メールアドレス', 'パスワード', 'パスワードリマインダ質問', 'パスワードリマインダ回答', '郵便番号１', '郵便番号２', '住所１', '住所２', '住所３', '会社名', '連絡先電話番号', '連絡先FAX番号', 'お支払い方法', '生年月日', '性別', '職業', 'サイトを知った場所', '情報メール', '作成日時', '更新日時']
      $custs.each do |cust|
	csv << [cust.id, cust.memberlevelcode, cust.custcompanyflg, cust.custname, cust.custpronname, cust.email, cust.password, cust.pwquestion, cust.pwanswer, cust.postcode1, cust.postcode2, cust.address1, cust.address2, cust.address3, cust.companyname, cust.tel, cust.fax, cust.paymethodcode, cust.birthdate, cust.sex, cust.job, cust.howtoknow, cust.newmailflg, cust.created_at, cust.updated_at]
      end
    end
    send_file(filepath,
              :type => 'text/csv',
              :filename => filename)
  end

  def sendmail
    $custs.each do |cust|
      if cust.newmailflg == 1
	mail = UserMailer.notice(cust)
	mail.deliver
	end
    end
  end

  def dm
    f = File.open("public/dm/filename.txt","w")
    $custs.each do |cust|
      f.write cust.postcode1 + "-" + cust.postcode2 + " "
      f.write cust.address1 + cust.address2
      #f.write cust.address3 + " "
      f.write " " + cust.custname
      f.write "\n"
    end
    f.close
  end

end
