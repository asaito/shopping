class StockmsController < ApplicationController
  def index
    @stockm = Stockm.new
    i = 0
    if params['confirm_image.x'] != nil
      savestock
    elsif params[:select_image] != nil
      while i < params[:line_no].to_i
	if params[:select_image][i.to_s] != nil
	  @stockm = Stockm.find_by_stockcode(params[:stockcode][i.to_s])
	end
	i += 1
      end 
    elsif params[:delete_image] != nil
      while i < params[:line_no].to_i
        if params[:delete_image][i.to_s] != nil
          Stockm.where("stockcode = ?", params[:stockcode][i.to_s]).destroy_all
        end
        i += 1
      end
    else
      @stockm.stockcode = ""
      @stockm.stockname = ""
      @stockm.tel = ""
      @stockm.fax = ""
      @stockm.chargeusername = ""
      @stockm.email = ""
    end
    @stockms = Stockm.find(:all, :order => "stockcode")
=begin
    @stockm = Stockm.find_by_stockcode("1")
    @stockcoden = params[:stockcoden]
    @stocknamen = params[:stocknamen]
    @teln = params[:teln]
    @faxn = params[:faxn]
    @chargeusernamen = params[:chargeusernamen]
    @emailn = params[:emailn]
=end

    @line_no = @stockms.size

  end

  def savestock
    @stockm = Stockm.find_by_stockcode(params[:stockcoden])
    if @stockm == nil
      @stockm = Stockm.new
    end
    @stockm.shopcode = "1"
    @stockm.stockcode = params[:stockcoden]
    @stockm.stockname = params[:stocknamen]
    @stockm.tel = params[:teln]
    @stockm.fax = params[:faxn]
    @stockm.email = params[:emailn]
    @stockm.chargeusername = params[:chargeusernamen]
    @stockm.save
  end

end
