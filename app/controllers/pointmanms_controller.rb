class PointmanmsController < ApplicationController
  def index
    logd("params[:id_serch]:", params[:id_serch])
    logd("params[:memberlevel_serch]:", params[:memberlevel_serch])
    logd("params[:custname_serch]:", params[:custname_serch])
    logd("params[:custname_serch]:", params[:custname_serch])
    @id_serch = params[:id_serch]
    @memberlevel_serch = params[:memberlevel_serch]
    @custname_serch = params[:custname_serch]
    @custpronname_serch = params[:custpronname_serch]
    if params["serch_image.x"] 
      @serchwhere = getwhere
      logd("@serchwhere:", @serchwhere)
    elsif params["delpoint_image.x"] 
      logd("$custs:", $custs)
      $custs.each do |c|
	Pointmanm.where("issueflg = ? AND custid = ?", 0, c.id).destroy_all
      end
    elsif params["addpoint_image.x"] 
      i = 0
      $custs.each do |c|
	pointmanm = Pointmanm.new
	pointmanm.mallshopcode = "1"
	pointmanm.issueflg = 2
	pointmanm.enableflg = 1
	pointmanm.issuedatetime = Time.now
	logd("params[:addpoint][i.to_s]:", params[:addpoint][i.to_s])
	pointmanm.pointofissue = params[:addpoint][i.to_s].to_i
	pointmanm.custid = c.id
	if pointmanm.pointofissue > 0
	  pointmanm.save
	end
	i += 1
      end
    end
    @memberlevelms = Memberlevelm.all
    @custs = Cust.paginate(:page => params[:page], :conditions => @serchwhere, :order => 'id asc', :per_page => 10)
    $custs = @custs
    logd("@custs.size:", @custs.size)
    @names = memberlevelname(@custs, @memberlevelms)
    @mks, @yks, @krs = custpoints(@custs)
  end

  def memberlevelname(custs, memberlevelms)
    names = []
    custs.each do |cust| 
      memberlevelms.each do |m|
	if cust.memberlevelcode == m.id
	  names.push(m.memberlevelname)
	  break
	end
      end
    end
    names
  end

  def getwhere
    where = ""
    nextop = ""
    if params[:id_serch] != nil && params[:id_serch] != ""
      where = "id = '" + params[:id_serch] + "'"
      nextop = " AND "
    else
      nextop = ""
    end
    if params[:memberlevel_serch] != ""
      where += nextop + "memberlevelcode = '" + params[:memberlevel_serch] + "'"
      nextop = " AND "
    end
    if params[:custname_serch] != nil &&  params[:custname_serch] != ""
      where += nextop + "custname like " + "\'%" + params[:custname_serch] + "%\'"
    end
    if params[:custpronname_serch] != nil && params[:custpronname_serch] != ""
      where += nextop + "custpronname like " + "\'%" + params[:custpronname_serch] + "%\'"
    end
    return where  
  end

  def custpoints(custs)
    # issueflg:0  購入時ポイント
    # issueflg:1  レビュー時ポイント
    # issueflg:2  管理画面での追加ポイント
    # enableflg:0 無効	仮発行はこちら	
    # enableflg:1 有効	入金時にこちらに変わる
    # enableflg:2 仮発行
    mks = []
    yks = []
    krs = []
    point_mks = Pointmanm.where("issueflg" => 0, "enableflg" => 0)
    point_krs = Pointmanm.where("issueflg" => 0, "enableflg" => 2)
    point_yks = Pointmanm.where("enableflg" => 1)
    logd("point_yks.first:", point_yks.first)
    custs.each do |cust|
      pt = 0
      point_mks.each do |mk|
	if mk.custid == cust.id
	  pt += mk.pointofissue
	end
      end
      mks.push(pt)

      pt = 0
      point_yks.each do |yk|
	if yk.custid == cust.id
	  pt += yk.pointofissue
	end
      end
      yks.push(pt)

      pt = 0
      point_krs.each do |kr|
        if kr.custid == cust.id
          pt += yk.pointofissue
        end
      end
      krs.push(pt)
    end
    return mks, yks, krs
  end

end
