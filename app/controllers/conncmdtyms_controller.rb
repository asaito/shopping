class ConncmdtymsController < ApplicationController
  def index
    @cmdtycode = params[:cmdtycode]
    @cmdtyname = params[:cmdtyname]
    if params['close_image.x'] != nil
      redirect_to comdties_url
      return
    elsif params['delete_image'] != nil
      i = 0
      logd("params[:conncmdtyms_size]:", params[:conncmdtyms_size])
      while i < params[:conncmdtyms_size].to_i
	logd("params[:delete_image]["+i.to_s+"]:", params[:delete_image][i.to_s])
	if params[:delete_image][i.to_s] != nil
	  logd("params[:cmdtycoden]["+i.to_s+"]:", params[:cmdtycoden][i.to_s])
	  Conncmdtym.where("conncmdtycode = ?", params[:cmdtycoden][i.to_s]).destroy_all
	end
	i += 1
      end
    elsif params['update_image'] != nil
      i = 0
      while i < params[:conncmdtyms_size].to_i
	if params[:update_image][i.to_s] != nil
	  conncmdtym = Conncmdtym.find_by_conncmdtycode(params[:cmdtycoden][i.to_s])
	  conncmdtym.disporder = params[:disporder][i.to_s]
	  conncmdtym.save
	end
	i += 1
      end
    elsif params['confirm_image.x'].to_i > 0
      @conncmdtycode = params[:conncmdtycode]
      logd("@conncmdtycode:", @conncmdtycode)
      @conncmdtyname = Comdty.find_by_cmdtycode(@conncmdtycode).cmdtyname
      #conncmdtyname
      logd("@conncmdtyname:", @conncmdtyname)
      cncm = Conncmdtym.find_by_cmdtycode_and_conncmdtycode(@cmdtycode, @conncmdtycode)
      logd("cncm:", cncm)
      if cncm == nil
	conncmdtym = Conncmdtym.new
	conncmdtym.shopcode = "1"
	conncmdtym.cmdtycode = @cmdtycode
	conncmdtym.connshopcode = conncmdtym.shopcode 
	conncmdtym.conncmdtycode = @conncmdtycode 
	conncmdtym.save
      end
    end
    @conncmdtyms = Conncmdtym.where(:cmdtycode => params[:cmdtycode])
    @conncmdtyms_size = @conncmdtyms.size
    @names = name(@conncmdtyms)
    logd("@names:", @names)
  end

  def name(conncmdtyms)
    names = []
    conncmdtyms.each do |c|
      names.push(Comdty.find_by_cmdtycode(c.conncmdtycode).cmdtyname)
    end
    names
  end

end
