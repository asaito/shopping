# -*- encoding: utf-8 -*-
class StndrdnamemsController < ApplicationController
  def index
    @stndrdnamems = Stndrdnamem.find(:all, :order => 'stndrdcode asc')
    @msg = ""
    @num_list = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']
    if params[:page] == nil
      if params[:line_no] != nil
        $sel_no = params[:line_no]
      end
    end

    logd("params['add_image.x']:", params['add_image.x'])
    if params[:stndrdnamem] != nil
      logd("params[:stndrdnamem]:", params[:stndrdnamem])
      logd("params[:stndrdnamem]['stndrdcode']:", params[:stndrdnamem]['stndrdcode'])
      logd("params[:stndrdnamem]['stndrdname']:", params[:stndrdnamem]['stndrdname'])
    end
    if params['add_image.x'].to_i > 0
      stndrdnamem = Stndrdnamem.new
      stndrdnamem.shopcode = 1
      stndrdnamem.stndrdcode = params[:stndrdcodeNew]
      stndrdnamem.stndrdname = params[:stndrdnameNew]
      stndrdnamem.save
      @msg = "登録しました。"
    end
    i = 0
    if params[:upd_image] != nil
      while i < $sel_no.to_i
	if params[:upd_image][i.to_s] != nil
	  logd("params[:upd_image][" + i.to_s + "][.x]:", params[:upd_image][i.to_s]['.x'])
	end
        if params[:stndrdid] != nil
          logd("params[:stndrdid][" + i.to_s + "]:", params[:stndrdid][i.to_s])
        end

	if params[:stndrdcode] != nil
	  logd("params[:stndrdcode][" + i.to_s + "]:", params[:stndrdcode][i.to_s])
	end
	if params[:stndrdcode] != nil
	  logd("params[:stndrdname][" + i.to_s + "]:", params[:stndrdname][i.to_s])
	end
        if params[:upd_image][i.to_s] != nil
          logd("params[:upd_image][" + i.to_s + "][.x]:", params[:upd_image][i.to_s]['.x'])
	  stndrdnamem = Stndrdnamem.find_by_id(params[:stndrdid][i.to_s])
	  stndrdnamem.stndrdcode = params[:stndrdcode][i.to_s]
	  stndrdnamem.stndrdname = params[:stndrdname][i.to_s]
	  stndrdnamem.save
	  @msg = "更新しました。"
	  break
        end
	i += 1
      end
    elsif params[:del_image] != nil
      while i < $sel_no.to_i
	if params[:del_image][i.to_s] != nil
	  stndrdnamem = Stndrdnamem.find_by_id(params[:stndrdid][i.to_s])
	  if stndrdnamem != nil
	    stndrdnamem.destroy
	    @msg = "削除しました。"
	  end
	  break
	end
	i += 1
      end
    end
    cond = ""
    if params[:srchStndrdName] != nil && params[:srchStndrdName] != ""
      cond = "stndrdname like '%" + params[:srchStndrdName] + "%'"
      @srchStndrdName = params[:srchStndrdName]
    else
      @srchStndrdName = ""
    end
    logd("cond:", cond)
    if cond == ""
      stndrdnamems = Stndrdnamem.find_by_sql("select * from stndrdnamems")
    else
      stndrdnamems = Stndrdnamem.find_by_sql("select * from stndrdnamems where " + cond)
    end
    if stndrdnamems != nil
      @total = stndrdnamems.size
    else
      @total = 0
    end
    @stndrdnamems = Stndrdnamem.paginate(:page => params[:page], :conditions => cond, :order => 'stndrdcode asc', :per_page => $sel_no)
    @prev = "<<前"
    @next = "次>>"
    logd("last @stndrdnamems.size:", @stndrdnamems)
    logd("$sel_no:", $sel_no)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stndrdnamems }
    end
  end

  def edit
    logd("come to Stndrdnamem edit", "")
  end

end
