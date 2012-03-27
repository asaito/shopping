# -*- encoding: utf-8 -*-
class CmctgriesController < ApplicationController
  def index
  end

  def edit
    flash[:notice] = ""
    if params[:cmdtycode] != nil && params[:id] != "edit"
      # 商品マスタ一覧画面からきた
      $cmdtyid = params[:id]
      $cmctcmdtycode = params[:cmdtycode]
      $ctgname = []
      #@comdty = Comdty.find($cmdtyid.to_i)
    elsif params[:cmdtycode] == nil && params[:id] != "edit"
      # treeのカテゴリ名をクリックした 
      #@comdty = Comdty.find_by_cmdtyname(params[:id])
    elsif params[:cmdtycode] == nil && params[:id] == "edit"  
      #	登録ボタンを押した
      #@comdty = Comdty.find($cmdtyid.to_i)
    end
    @comdty = Comdty.find($cmdtyid.to_i)
    #@ctgrymtbls = Ctgrymtbl.all
    $tree = Tree.new
    @name_ary = Array.new
    @ctgcd_ary = Array.new
    @depth = 0
    $from_cmdtylists = 0
    list_tree
    #$htmlstr = "test"
    
    logd("params['add_image.x']:", params['add_image.x'])
    logd("params['del_image.x']:", params['del_image.x'])
    logd("params['del_image3.x']:", params['del_image3.x'])
    logd("params['del_data3']:", params['del_data3'])
    logd("params[:id]:", params[:id])
    logd("params[:cmdtycode]:", params[:cmdtycode])
    logd("$cmdtyid:", $cmdtyid)
    logd("$ctgname:", $ctgname)
    logd("$cmctcmdtycode:", $cmctcmdtycode)

    #if params['add_image.x'].to_i > 0

    if params[:cmdtycode] == nil && params[:id] != "ctgryReg" && params[:id] != "edit"
      # treeのカテゴリ名をクリックした
      #$ctgnew = CmdtyctgryCtgryView.new
      #$ctgnew = CmdtyctgryCtgryView.new
      #$ctgnew.ctgryname = params[:id]
      #$ctgname = params[:id]
      logd("before $ctgname.size:", $ctgname.size)
      $ctgname.push(params[:id])
      logd("after $ctgname.size:", $ctgname.size)
    elsif params['close_image.x'].to_i > 0
      redirect_to comdties_url
      return
    elsif params[:id] == "ctgryReg"
      logd("come to button:", "")
      if params['add_image.x'].to_i > 0
	logd("come to add:", "")
	# 登録ボタンをクリックした
	$ctgname.each do |nm|
	  cmctg = Cmdtyctgry.new
	  cmctg.shopcode = 1
	  cmctg.cmdtycode = @comdty.cmdtycode
	  ctg = Ctgrymtbl.find_by_ctgryname(nm)
	  logd("nm:", nm)
	  logd("ctg:", ctg)
	  cmc = Cmdtyctgry.find_by_sql("select * from cmdtyctgries where ctgrycode = '" + ctg.ctgrycode + "' and cmdtycode = '" + @comdty.cmdtycode + "'") 
	  logd("cmc:", cmc)
	  if cmc.size > 0
	    flash[:notice] = "カテゴリーがすでに登録されています。"
	    #$ctgname = []
	    break
	  end
	  cmctg.ctgrycode = ctg.ctgrycode
	  cmctg.cmdtyname = @comdty.cmdtyname
	  logd("come to save:", "")
	  cmctg.save
	end
	$ctgname = []
      else 
	flg = 0
	dt = ""
	if params['del_image0.x'].to_i > 0
	  dt = params['del_data0']
	elsif params['del_image1.x'].to_i > 0
	  dt = params['del_data1']
	elsif params['del_image2.x'].to_i > 0
	  dt = params['del_data2']
	elsif params['del_image3.x'].to_i > 0
	  dt = params['del_data3']
	elsif params['del_image4.x'].to_i > 0
	  dt = params['del_data4']
	elsif params['del_image5.x'].to_i > 0
	  dt = params['del_data5']
	elsif params['del_image6.x'].to_i > 0
	  dt = params['del_data6']
	elsif params['del_image7.x'].to_i > 0
	  dt = params['del_data7']
	elsif params['del_image8.x'].to_i > 0
	  dt = params['del_data8']
	elsif params['del_image9.x'].to_i > 0
	  dt = params['del_data9']
	elsif params['del_image10.x'].to_i > 0
	  dt = params['del_data10']
	elsif params['del_image11.x'].to_i > 0
	  dt = params['del_data11']
	elsif params['del_image12.x'].to_i > 0
	  dt = params['del_data12']
	elsif params['del_image13.x'].to_i > 0
	  dt = params['del_data13']
	elsif params['del_image14.x'].to_i > 0
	  dt = params['del_data14']
	elsif params['del_image15.x'].to_i > 0
	  dt = params['del_data15']
	elsif params['del_image16.x'].to_i > 0
	  dt = params['del_data16']
	elsif params['del_image17.x'].to_i > 0
	  dt = params['del_data17']
	elsif params['del_image18.x'].to_i > 0
	  dt = params['del_data18']
	elsif params['del_image19.x'].to_i > 0
	  dt = params['del_data19']
	elsif params['del_image20.x'].to_i > 0
	  dt = params['del_data20']
	elsif params['del_image21.x'].to_i > 0
	  dt = params['del_data21']
	elsif params['del_image22.x'].to_i > 0
	  dt = params['del_data22']
	elsif params['del_image23.x'].to_i > 0
	  dt = params['del_data23']
	elsif params['del_image24.x'].to_i > 0
	  dt = params['del_data24']
	elsif params['del_image25.x'].to_i > 0
	  dt = params['del_data25']
	elsif params['del_image26.x'].to_i > 0
	  dt = params['del_data26']
	elsif params['del_image27.x'].to_i > 0
	  dt = params['del_data27']
	elsif params['del_image28.x'].to_i > 0
	  dt = params['del_data28']
	elsif params['del_image29.x'].to_i > 0
	  dt = params['del_data29']
	elsif params['del_image30.x'].to_i > 0
	  dt = params['del_data30']
	else
	  flg = 1 
	end
	if flg == 0
	  logd("dt:", dt)
	  nm = Ctgrymtbl.find_by_ctgryname(dt)
	  logd("nm.ctgrycode:", nm.ctgrycode)
	  Cmdtyctgry.where("ctgrycode = ?", nm.ctgrycode).destroy_all
	end
      end
    end

    @cmdtyctgries = CmdtyctgryCtgryView.find_by_sql(["select * from cmdtyctgry_ctgry_views where cmdtycode = '" + $cmctcmdtycode + "'"])
    if @cmdtyctgries.first != nil
      logd("@cmdtyctgries.first.ctgryname:", @cmdtyctgries.first.ctgryname)
    end
    #if $ctgnew != nil
      #logd("just before exit$ctgnew.ctgryname:", $ctgnew.ctgryname)
    #end
    
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @comdty }
    end
  end

  def show
    logd("show params['add_image.x']:", params['add_image.x'])
    edit
  end

end
