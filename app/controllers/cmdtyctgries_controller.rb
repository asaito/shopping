# -*- encoding: utf-8 -*-
class CmdtyctgriesController < ApplicationController
  def index
    if params['del_image.x']
      delids = []
      checked = params[:checked_items]
      checked.each{|key, value|
        logger.debug 'checked1.key:' + key
        delids.push(key)
        value.each{|key, value|
          logger.debug 'checked2.key:' + key
          logger.debug 'checked2.value:' + value
        }
      }
      logger.debug 'delids.length:' + delids.length.to_s
      for i in 0..delids.length - 1
        logger.debug 'delids' + '[' + i.to_s + ']:' + delids[i]
      end
      Cmdtyctgry.delete(delids)
      respond_to do |format|
        format.html { redirect_to(cmdtyctgries_url) }
        format.xml  { head :ok }
      end
      return
    elsif params['close_image.x']
      logd("params[:ctgryCode]:", params[:ctgryCode])
      $ctgryname = params[:ctgryCode]
      @ctgrymtbl = Ctgrymtbl.find_by_ctgrycode(params[:ctgryCode])
      respond_to do |format|
        format.html { redirect_to $ctgrymtbl }
        format.xml  { head :ok }
      end
      return
    elsif params['reload_image.x']
      respond_to do |format|
        format.html { redirect_to(cmdtyctgries_url) }
        format.xml  { head :ok }
      end
      return
    elsif params['allsel_image.x']
      $checked = true
      respond_to do |format|
        format.html { redirect_to(cmdtyctgries_url) }
        format.xml  { head :ok }
      end
      return
    elsif params['allrel_image.x']
      $checked = false
      respond_to do |format|
        format.html { redirect_to(cmdtyctgries_url) }
        format.xml  { head :ok }
      end
      return
    elsif params['addnew_image.x'].to_i > 1
      addNew
      $ctgryname = params[:ctgryName]
      $ctgryCode = params[:ctgryCode]
    end
    logd("$ctgrymtbl:", $ctgrymtbl)
    serchwhere = "ctgrycode = '" + $ctgrymtbl.ctgrycode + "'"
    @cmdtyctgries = Cmdtyctgry.paginate(:page => params[:page], :conditions => serchwhere, :order => 'cmdtycode asc', :per_page => 10)
    
    cmdtyctgries = Cmdtyctgry.find_by_sql(["select * from cmdtyctgries where ctgrycode = '" + $ctgrymtbl.ctgrycode + "'"]) 
    @cmdtycount = cmdtyctgries.size
    logd("$ctgryname:", $ctgryname)
    logd("$ctgryCode:", $ctgryCode)
    logd("serchwhere:", serchwhere)
    logd("@cmdtyctgries:", @cmdtyctgries)
    logd("@cmdtycount:", @cmdtycount)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cmdtyctgries }
    end
  end

  def addNew
    @cmdtycode = params[:comdtyCode]
    cmdtyctgries = Cmdtyctgry.find_by_sql(["select * from cmdtyctgries where ctgrycode = '" + params[:ctgryCode] + "' and cmdtycode = '" + params[:comdtyCode] + "'"]) 
    if cmdtyctgries.size > 0
        flash[:notice] = "商品コードがすでに登録されています。"
        return
    end
    cmdtyctgry = Cmdtyctgry.new
    cmdtyctgry.ctgrycode = params[:ctgryCode]
    cmdtyctgry.shopcode = "1"
    cmdtyctgry.cmdtycode = params[:comdtyCode]
    cmdtyctgry.cmdtyname = Comdty.find_by_cmdtycode(cmdtyctgry.cmdtycode).cmdtyname 
    cmdtyctgry.save
  end

end
