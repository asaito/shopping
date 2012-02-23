# -*- encoding: utf-8 -*-
class CmdtystndrdmsController < ApplicationController
  def index
    getparams
    logd("@cmdtycode:", @cmdtycode)
    @allcheck = 0
    if params['allsel_image.x'].to_i > 1
      @allcheck = 1
      srch_display
    elsif params['allrel_image.x'].to_i > 1
      @allcheck = 0
      srch_display
    elsif params['srch_image.x'].to_i > 0
      srch_display
    elsif params['confirm_image.x'].to_i > 0
      additems = checkitems
      cmst = Cmdtystndrdm.new	
      cmst.shopcode = "1"
      cmst.cmdtycode = @cmdtycode
      additems.each do |a|
	if a.to_i < $stndrdcontentm1.size
	  cmst.stndrdcode1 = Stndrdnamem.find_by_stndrdname(params[:stnd1]).stndrdcode
	  cmst.elementcode1 = params[:elementcode][a]
	else
	  cmst.stndrdcode2 = Stndrdnamem.find_by_stndrdname(params[:stnd2]).stndrdcode
	  cmst.elementcode2 = params[:elementcode][a]
	end
	cmst.amount = params[:amount][a].to_i
      end
      cmst.save
      srch_display
    else
      indexfromcmdty
    end
    @stndrdname_all = stndnamelist(Stndrdnamem.all)
    logd("Stndrdnamem.all:", Stndrdnamem.all)
    logd("@stndrdname_all:", @stndrdname_all)
  end

  def stnd_nm_to_cd(nm)
    Stndrdnamem.find_by_stndrdname(nm).stndrdcode  
  end

  def checkitems
      checked = params[:checked_items]
      additems = []
      checked.each{|key, value|
        #logger.debug 'checked1.key:' + key
        additems.push(key)
        value.each{|key, value|
          #logger.debug 'checked2.key:' + key
          #logger.debug 'checked2.value:' + value
        }
      }
      logger.debug 'additems.length:' + additems.length.to_s
      for i in 0..additems.length - 1
        logger.debug 'additems' + '[' + i.to_s + ']:' + additems[i]
      end
      additems
  end

  def srch_display
      logd("params[:stnd1]:", params[:stnd1])
      $stndrdcontentm1 = []
      if params[:stnd1] != "指定しない"
        stndrdcode = Stndrdnamem.find_by_stndrdname(params[:stnd1]).stndrdcode
        sql = "select * from stndrdcontentms where stndrdcode = '" + stndrdcode + "' order by disporder"
        logd("sql:", sql)
        $stndrdcontentm1 = Stndrdcontentm.find_by_sql(sql)
      end
      @stndrdcontentm2 = []
      if params[:stnd2] != "指定しない"
        stndrdcode = Stndrdnamem.find_by_stndrdname(params[:stnd2]).stndrdcode
        sql = "select * from stndrdcontentms where stndrdcode = '" + stndrdcode + "' order by disporder"
        logd("sql:", sql)
        @stndrdcontentm2 = Stndrdcontentm.find_by_sql(sql)
      end
      @stndrdname1 = params[:stnd1]
      @stndrdname2 = params[:stnd2]
  end

  def getparams
    @cmdtycode = params[:cmdtycode]
    @cmdtyname = params[:cmdtyname]
  end

  def indexfromcmdty
    sql = "select stndrdcode1, stndrdcode2 from cmdtystndrdm_stndrdcontentm_views where cmdtycode = '" + @cmdtycode + "'"
    logd("sql:", sql)
    logd("@cmdtyname:", @cmdtyname)
    @cmstnd = CmdtystndrdmStndrdcontentmView.find_by_sql(sql)
    logd("@cmstnd:", @cmstnd)
    stndrdname1 = Stndrdnamem.new
    stndrdname2 = Stndrdnamem.new
    #@stndrdcode1 = ""
    #@stndrdcode2 = ""
    if @cmstnd != []
      stndrdname1 = Stndrdnamem.find_by_stndrdcode(@cmstnd.first.stndrdcode1)
      stndrdname2 = Stndrdnamem.find_by_stndrdcode(@cmstnd.first.stndrdcode2)
      @stndrdcode1 = @cmstnd.first.stndrdcode1
      @stndrdcode2 = @cmstnd.first.stndrdcode2
    end
    logd("stndrdname1.stndrdname:", stndrdname1.stndrdname)
    logd("stndrdname2:", stndrdname2)
    #@stndrdname1 = Stndrdnamem.new
    @stndrdname1 = ""
    @stndrdname2 = ""
    if stndrdname1 != nil && stndrdname1.stndrdname != nil
      @stndrdname1 = stndrdname1.stndrdname
    else
      @stndrdname1 = "指定しない"
    end
    if stndrdname2 != nil && stndrdname2.stndrdname != nil
      @stndrdname2 = stndrdname2.stndrdname
    else
      @stndrdname2 = "指定しない"
    end
    logd("@stndrdname1:", @stndrdname1)
    logd("@stndrdname2:", @stndrdname2)
    $stndrdcontentm1 = []
    if @cmstnd != []
      sql = "select * from stndrdcontentms where stndrdcode = '" + @cmstnd.first.stndrdcode1 + "' order by disporder"
      logd("sql:", sql)
      $stndrdcontentm1 = Stndrdcontentm.find_by_sql(sql)
    end
    logd("$stndrdcontentm1:", $stndrdcontentm1)
    @stndrdcontentm2 = []
    if @cmstnd != []
      sql = "select * from stndrdcontentms where stndrdcode = '" + @cmstnd.first.stndrdcode2 + "' order by disporder"
      logd("sql:", sql)
      @stndrdcontentm2 = Stndrdcontentm.find_by_sql(sql)
    end
    logd("@stndrdcontentm2:", @stndrdcontentm2)
  end
  
  def stndnamelist(a)
    ret = []
    a.each do |n|
      ret.push(n.stndrdname)
    end
    ret.push("指定しない")
    ret
  end
end
