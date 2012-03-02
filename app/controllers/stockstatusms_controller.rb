# -*- encoding: utf-8 -*-
class StockstatusmsController < ApplicationController
  def index
    i = 0
    if params['confirm_image.x'] != nil
      savestockstatus
    elsif params[:select_image] != nil
      while i < params[:line_no].to_i
        if params[:select_image][i.to_s] != nil
          @stockstatusm = Stockstatusm.find_by_id(params[:stockstatusid][i.to_s].to_i)
        end
        i += 1
      end
    elsif params['reset_image.x'] != nil
      @stockstatusm = Stockstatusm.new
      @stockstatusm.id = params[:stockstatusidn].to_i
      logd("@stockstatusm.id:", @stockstatusm.id)
      comdties = Comdty.find_by_stockstatuscode(@stockstatusm.id)
      if comdties == nil
	Stockstatusm.destroy(@stockstatusm.id)
      end
    else
      @stockstatusm = Stockstatusm.new
      @stockstatusm.stockstatuscode = @stockstatusm.id
      @stockstatusm.stockstatusname = ""
      @stockstatusm.commentofnostock = ""
      @stockstatusm.amountoflessstock = ""
      @stockstatusm.commentoflessstock = ""
      @stockstatusm.commentofmorestock = ""
    end
    @stockstatusms = Stockstatusm.find(:all)

    @line_no = @stockstatusms.size
  end

  def savestockstatus
    @stockstatusm = Stockstatusm.find_by_stockstatuscode(params[:stockstatuscoden])
    if @stockstatusm == nil
      @stockstatusm = Stockstatusm.new
    end
    @stockstatusm.stockstatuscode = 1 #@stockstatusm.id
    @stockstatusm.stockstatusname = params[:stockstatusnamen]
    @stockstatusm.commentofnostock = params[:commentofnostockn]
    @stockstatusm.amountoflessstock = params[:amountoflessstockn].to_i
    @stockstatusm.commentoflessstock = params[:commentoflessstockn]
    @stockstatusm.commentofmorestock =  params[:commentofmorestockn]

    @stockstatusm.save
  end

end
