# -*- encoding: utf-8 -*-
class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.xml
  # status:0 通常
  # status:1 キャンセル
  # status:2 返品
  # paymentflg:0 未入金
  # paymentflg:1 入金済
  # receiptmailflg:0 入金aメール未送信
  # receiptmailflg:1 入金aメール送信済
  def index
    Time.zone = 'Tokyo'
    @orders = Order.all
    @num_list = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']


    @paymethod_list = ["選択してください", "現金", "銀行振込", "クレジットカード", "コンビニ決済", "代金引換"]
    #@sel_paymethod = 2
    #$sel_paymethod = params[:paymethodname]
    $disporder_list = ["受注日", "顧客名カナ", "メールアドレス", "入金日", "支払方法", "入金状況", "受注状態"]
    #$disporder = 2
    logd("$orderfrom:", $orderfrom)
    if $orderfrom == nil
      $orderfrom = Date.today
      $orderto = Date.today
      $receivefrom = Date.today
      $receiveto = Date.today
      $payment_mailflg = "all"
      $status = "all"
      $sel_no_cm = "10"
      $disporder = "受注日"
      $setdate = Date.today
    end
    #logd("@paymethod_list:", @paymethod_list)
    logd("$serchwhere:", $serchwhere)
    logd("$sel_paymethod:", $sel_paymethod)
    logd("$dispseq:", $dispseq)
    @orders = Order.paginate(:page => params[:page], :conditions => $serchwhere, :order => $dispseq, :per_page => $sel_no_cm)
    #@orders = Order.paginate(:page => params[:page], :conditions => $serchwhere, :order => 'id asc', :per_page => $sel_no_cm)

    odtotal = Order.where($serchwhere)
    if odtotal != nil
      @total = odtotal.size
    else
      @total = 0
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml
  def create
    Time.zone = 'Tokyo'
    @num_list = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']
    @paymethod_list = ["選択してください", "現金", "銀行振込", "クレジットカード", "コンビニ決済", "代金引換"]
    if params[:page] == nil
      if params[:line_no] != nil
        $sel_no_cm = params[:line_no]
      else
        $sel_no_cm = "10"
      end
    end

    $disporder = params[:disporder]
    if params['allsel_image.x']
      $checked = true
      respond_to do |format|
        format.html { redirect_to(orders_url) }
        format.xml  { head :ok }
      end
    elsif params['allrel_image.x']
      $checked = false
      respond_to do |format|
        format.html { redirect_to(orders_url) }
        format.xml  { head :ok }
      end
    elsif params['new_image.x']
      @order = Order.new(params[:order])

      respond_to do |format|
        if @order.save
          format.html { redirect_to(@order, :notice => 'Comdty was successfully created.') }
          format.xml  { render :xml => @order, :status => :created, :location => @order }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
        end
      end
    elsif params['serch_image.x']
      if params[:disporder] == "受注日"
	$dispseq = "initdatetime asc"
      elsif params[:disporder] == "顧客名カナ"
	$dispseq = "custpronname asc"
      elsif params[:disporder] == "メールアドレス"
	$dispseq = "email asc"
      elsif params[:disporder] == "入金日"
	$dispseq = "receiptdate asc"
      elsif params[:disporder] == "支払方法"
	$dispseq = "paymethodname asc"
      elsif params[:disporder] == "入金状況"
	$dispseq = "paymentflg, receiptmailflg asc "
      elsif params[:disporder] == "受注状態"
	$dispseq = "status asc"
      end
      $serchwhere = getConditions()
      logd("$serchwhere:", $serchwhere)
      setval
      respond_to do |format|
	format.html { redirect_to(orders_url) }
	format.xml  { head :ok }
      end
      return
    else
      @order = Order.new(params[:order])
      respond_to do |format|
        if @order.save
          format.html { redirect_to(@order, :notice => 'Comdty was successfully created.') }
          format.xml  { render :xml => @order, :status => :created, :location => @order }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
        end
      end
      return
    end
  end

  def setval
    $custpronname_serch = params[:custpronname_serch]
    $email_serch = params[:email_serch]
    if params[:orderfrom] != nil
      $orderfrom = Date.new(params[:orderfrom]["year"].to_i, params[:orderfrom]["month"].to_i, params[:orderfrom]["day"].to_i)
    else
      $orderfrom = Date.today
    end
    if params[:orderto] != nil
      $orderto = Date.new(params[:orderto]["year"].to_i, params[:orderto]["month"].to_i, params[:orderto]["day"].to_i)
    else
      $orderto = Date.today
    end

    $payment_mailflg = params[:payment_mailflg]

    if params[:receivefrom] != nil
      $receivefrom = Date.new(params[:receivefrom]["year"].to_i, params[:receivefrom]["month"].to_i, params[:receivefrom]["day"].to_i)
    else
      $receivefrom = Date.today
    end
    if params[:receiveto] != nil
      $receiveto = Date.new(params[:receiveto]["year"].to_i, params[:receiveto]["month"].to_i, params[:receiveto]["day"].to_i)
    else
      $receiveto = Date.today
    end

    $sel_paymethod = params[:paymethodname]
    $status = params[:status]
  end

  def name2index(list, p)
    i = 0
    list.each do |ls|
      if ls == p
	return i
      end
      i += 1
    end
    0
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to(@order, :notice => 'Order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end

  def getConditions
    serchwhere = ""
    preceed = ""
    if params[:custpronname_serch] != nil
      serchwhere += "custpronname like " + "\'%" + params[:custpronname_serch] + "%\'"
      preceed = ' AND '
    end
    if params[:email_serch] != nil
      serchwhere += preceed +  "email like " + "\'%" + params[:email_serch] + "%\'"
      preceed = ' AND '
    end

    if params[:orderfrom] != nil
      orderfrom = Date.new(params[:orderfrom]["year"].to_i, params[:orderfrom]["month"].to_i, params[:orderfrom]["day"].to_i).yesterday.strftime("%Y%m%d")
      orderto = Date.new(params[:orderto]["year"].to_i, params[:orderto]["month"].to_i, params[:orderto]["day"].to_i).tomorrow.strftime("%Y%m%d")
      serchwhere += preceed + "initdatetime > " + "\'" + orderfrom + "\' AND " + "initdatetime < " + "\'" + orderto + "\'"
      preceed = ' AND '
    end

    if params[:payment_mailflg] != nil
      if params[:payment_mailflg] == "all"
      elsif params[:payment_mailflg] == "notpaid"
	serchwhere += preceed +  "paymentflg = " + "\'0\'"
	preceed = ' AND '
      elsif params[:payment_mailflg] == "paid"
	serchwhere += preceed +  "paymentflg = " + "\'1\'"
	preceed = ' AND '
      elsif params[:payment_mailflg] == "mailnotsent"
	serchwhere += preceed +  "receiptmailflg = " + "\'0\'"
	preceed = ' AND '
      end
    end
    if params[:receivefrom] != nil
      receivefrom = Date.new(params[:receivefrom]["year"].to_i, params[:receivefrom]["month"].to_i, params[:receivefrom]["day"].to_i).yesterday.strftime("%Y%m%d")
      receiveto = Date.new(params[:receiveto]["year"].to_i, params[:receiveto]["month"].to_i, params[:receiveto]["day"].to_i).tomorrow.strftime("%Y%m%d")
      serchwhere += preceed + "receiptdate > " + "\'" + receivefrom + "\' AND " + "receiptdate < " + "\'" + receiveto + "\'"
      preceed = ' AND '
    end
    if params[:paymethodname] != "選択してください"
      serchwhere += preceed + "paymethodname = " + "\'" + params[:paymethodname] + "\'"
      preceed = ' AND '
    end
    if params[:status] != nil
      if params[:status] == "all"
      elsif params[:status] == "nornal"
	serchwhere += preceed +  "status = " + "\'0\'"
	preceed = ' AND '
      elsif params[:status] == "cancel"
	serchwhere += preceed +  "status = " + "\'1\'"
	preceed = ' AND '
      end
    end
    serchwhere
  end

end
