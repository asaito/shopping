class WrappingmsController < ApplicationController
  def index
    logd("params[:wrappingcoden]:", params[:wrappingcoden])
    i = 0
    if params['confirm_image.x'] != nil
      savewrap
    elsif params[:select_image] != nil
      while i < params[:line_no].to_i
        if params[:select_image][i.to_s] != nil
	  @wrappingm = Wrappingm.find_by_wrappingcode(params[:wrappingcode][i.to_s])
        end
        i += 1
      end
    elsif params[:delete_image] != nil
      while i < params[:line_no].to_i
        if params[:delete_image][i.to_s] != nil
          Wrappingm.where("wrappingcode = ?", params[:wrappingcode][i.to_s]).destroy_all
        end
        i += 1
      end
    else 
      @wrappingm = Wrappingm.new
    end

    @wrappingms = Wrappingm.order("wrappingcode")

    @line_no = @wrappingms.size
    logd("@line_no:", @line_no)
  end

  def savewrap
    @wrappingm = Wrappingm.find_by_wrappingcode(params[:wrappingcoden])
    logd("@wrappingm:", @wrappingm)
    if @wrappingm == nil
      @wrappingm = Wrappingm.new
    end
    @wrappingm.shopcode = "1"
    @wrappingm.wrappingcode = params[:wrappingcoden]
    @wrappingm.wrappingname = params[:wrappingnamen]
    @wrappingm.description = params[:descriptionn]
    @wrappingm.price = params[:pricen].to_i
    @wrappingm.taxflg = gettaxflg
    logd("@wrappingm:", @wrappingm)
    logd("@wrappingm.taxflg:", @wrappingm.taxflg)
    @wrappingm.save
  end

  def gettaxflg
    logd("params[:taxflgn][:taxincluded]:", params[:taxflgn][:taxincluded])
    logd("params[:taxflgn][:taxexcluded]:", params[:taxflgn][:taxexcluded])
    logd("params[:taxflgn][:notax]:", params[:taxflgn][:notax])
    t = 1
    if params[:taxflgn][:taxincluded] != nil
      t = 1
    elsif params[:taxflgn][:taxexcluded] != nil
      t = 2
    elsif params[:taxflgn][:notax] != nil
      t = 3
    end
    t
  end

end
