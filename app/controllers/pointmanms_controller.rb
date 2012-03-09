class PointmanmsController < ApplicationController
  def index
    logd("params[:id_serch]:", params[:id_serch])
    logd("params[:memberlevel_serch]:", params[:memberlevel_serch])
    logd("params[:custname_serch]:", params[:custname_serch])
    logd("params[:custname_serch]:", params[:custname_serch])
    if params[:id_serch] != nil
      @id_serch = params[:id_serch]
      @memberlevel_serch = params[:memberlevel_serch]
      @custname_serch = params[:custname_serch]
      @custpronname_serch = params[:custpronname_serch]
      @serchwhere = getwhere
      logd("@serchwhere:", @serchwhere)
    else
      @id_serch = ""
      @memberlevel_serch = ""
      @custname_serch = ""
      @custpronname_serch = ""
      @serchwhere = ""
    end
    @memberlevelms = Memberlevelm.all
    @custs = Cust.paginate(:page => params[:page], :conditions => @serchwhere, :order => 'id asc', :per_page => 10)
    logd("@cust.size:", @custs.size)
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
    # issueflg:0  無効ポイント
    # issueflg:1  有効ポイント
    # issueflg:2  仮発行ポイント
    mks = []
    yks = []
    krs = []
    point_mks = Pointmanm.where("issueflg" => 0)
    point_yks = Pointmanm.where("issueflg" => 1)
    point_krs = Pointmanm.where("issueflg" => 2)
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
