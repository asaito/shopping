# -*- encoding: utf-8 -*-
class CustattrmsController < ApplicationController
  def index
    logd("params[:custattrbmgroup]:", params[:custattrbmgroup])
    @custattrms_list = ["職業", "サイトを知った場所", "趣味"]
    @sel_custattrm = ""
    if params[:custattrbmgroup] != nil
      @sel_custattrm = params[:custattrbmgroup]
    else
      @sel_custattrm = @custattrms_list[0]
    end
    flag = getattrflag(@custattrms_list, @sel_custattrm)
    logd("flag:", flag)
    if params[:upd_image]
      i = 0
      while i < params[:line_no].to_i
	if params[:upd_image][i.to_s]
	  @custattrm = Custattrm.find(params[:id][i.to_s].to_i)
	  @custattrm.attrflag = flag
	  @custattrm.attrname = params[:attrname][i.to_s]
	  @custattrm.disporder = params[:disporder][i.to_s].to_i
	  @custattrm.save
	end
	i += 1
      end
    elsif params[:del_image]
      i = 0
      while i < params[:line_no].to_i
        if params[:del_image][i.to_s]
	  @custattrm = Custattrm.find(params[:id][i.to_s].to_i)
	  @custattrm.destroy
	end
	i += 1
      end
    elsif params['new_image.x']
      @custattrm = Custattrm.new
      @custattrm.attrflag = flag
      @custattrm.attrname = params[:attrnamen]
      @custattrm.disporder = params[:dispordern].to_i
      @custattrm.save
    end
    @custattrms = Custattrm.find_by_sql("select * from custattrms where attrflag = '" + flag.to_s + "' order by disporder")
    logd("@custattrms:", @custattrms)
    @custattrm = Custattrm.new
    @custattrm.attrflag = flag
    @custattrm.attrname = params[:attrnamen]
    @custattrm.disporder = params[:dispordern].to_i
  end

  def getattrflag(groups, groupname)
    i = 0
    groups.each do |g|
      if g == groupname
	return i
      end
      i += 1
    end
    i
  end

end
