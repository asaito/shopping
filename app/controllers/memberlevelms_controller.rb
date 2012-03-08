class MemberlevelmsController < ApplicationController
  def index
    if params['confirm_image.x']
      memberlevelm = Memberlevelm.new
      memberlevelm.memberlevel = params[:memberleveln]
      memberlevelm.memberlevelname = params[:memberlevelnamen]
      memberlevelm.discountrate = params[:discountraten]
      memberlevelm.save
      @memberleveln = memberlevelm.memberlevel
      @memberlevelnamen = memberlevelm.memberlevelname
      @discountraten = memberlevelm.discountrate
    elsif params[:del_image]
      logd("params[:line_no]:", params[:line_no])
      i = 0
      while i < params[:line_no].to_i
	if params[:del_image][i.to_s] != nil
	  Memberlevelm.delete((params[:memberlevelmid][i.to_s]).to_i)
	end
	i += 1
      end
    elsif params[:reset_image]
      @memberleveln = 0
      @memberlevelnamen = ""
      @discountraten = 0
    end
    @memberlevelms = Memberlevelm.all
    @line_no = @memberlevelms.size
    logd("@line_no:", @line_no)
    #logd("@memberlevelms:", @memberlevelms)
    @custs = Cust.all
    @custcount = custcount(@memberlevelms, @custs)
    
  end

  def custcount(memberlevelms, custs)
    custcount = []
    memberlevelms.each do |ml|
      count = 0
      custs.each do |c|
	if ml.id == c.memberlevelcode
	  count += 1
	end
      end
      custcount.push(count)
    end
    custcount
  end

end
