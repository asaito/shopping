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
      cmstcntntview1size = 0
      if @cmstcntntview1 == nil
	cmstcntntview1size = params[:cmstcntntview1size].to_i
      else
	cmstcntntview1size = @cmstcntntview1.size
      end
      logd("cmstcntntview1size:", cmstcntntview1size)
      find1 = 0
      find2 = 0
      cmstd = Cmdtystndrdm.new
      elementcode1 = ""
      elementcode2 = ""
      amount = 0
      additems.each do |a|
	if a.to_i < cmstcntntview1size
	  if find1 == 0
	    elementcode1 = params[:elementcode][a]
	    amount = params[:amount][a].to_i
	    find1 = 1
	  end
	else
	  if find2 == 0
	    elementcode2 = params[:elementcode][a]
	    amount = params[:amount][a].to_i
	    find2 = 1
	  end
	end
	cmstd = cmstm(find1, find2, elementcode1, elementcode2, amount)
      end
      if find1 == 1 || find2 == 1
	logd("cmstd:", cmstd)
	cmstd.save
      end
      srch_display
    else
      indexfromcmdty
    end
    @stndrdname_all = stndnamelist(Stndrdnamem.all)
    logd("Stndrdnamem.all:", Stndrdnamem.all)
    logd("@stndrdname_all:", @stndrdname_all)
  end

  def cmstm(find1, find2, elementcode1, elementcode2, amount)
    cmst = Cmdtystndrdm.new
    if find1 == 1 && find2 == 1
      cmsts = Cmdtystndrdm.where(:cmdtycode => params[:cmdtycode], :stndrdcode1 =>  params[:stndrdcode1], :stndrdcode2 => params[:stndrdcode2])
      inserted = 0
      cmsts.each do |c|
	if c.elementcode1 == elementcode1 && c.elementcode2 == elementcode2
	  cmst = c
	  inserted = 1
	  break
	end
      end
      if inserted == 0
	cmst = Cmdtystndrdm.new
	cmst.shopcode = "1"
	cmst.cmdtycode = params[:cmdtycode]
	cmst.stndrdcode1 = params[:stndrdcode1]
	cmst.stndrdcode2 = params[:stndrdcode2]
	cmst.elementcode1 = elementcode1
	cmst.elementcode2 = elementcode2
      end
      cmst.amount = amount
    elsif find1 == 1 && find2 == 0
      cmsts = Cmdtystndrdm.where(:cmdtycode => params[:cmdtycode], :stndrdcode1 =>  params[:stndrdcode1])
      inserted = 0
      cmsts.each do |c|
        if c.elementcode1 == elementcode1
          cmst = c
          inserted = 1
          break
        end
      end
      if inserted == 0
        cmst = Cmdtystndrdm.new
        cmst.shopcode = "1"
	cmst.cmdtycode = params[:cmdtycode]
	cmst.elementcode1 = elementcode1
      end
      cmst.amount = amount
    elsif find1 == 0 && find2 == 1
      cmsts = Cmdtystndrdm.where(:cmdtycode => params[:cmdtycode], :stndrdcode2 =>  params[:stndrdcode2])
      inserted = 0
      cmsts.each do |c|
        if c.elementcode2 == elementcode2
          cmst = c
          inserted = 1
          break
        end
      end
      if inserted == 0
        cmst = Cmdtystndrdm.new
        cmst.shopcode = "1"
	cmst.cmdtycode = params[:cmdtycode]
	cmst.elementcode2 = elementcode2
      end
      cmst.amount = amount
    end
    cmst
  end

  def checkitems
      checked = params[:checked_items]
      additems = []
      if checked == nil
	return additems
      end
      checked.each{|key, value|
        additems.push(key)
        value.each{|key, value|
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
      @cmstcntntview1 = []
      if params[:stnd1] != "指定しない"
        stndrdcode = Stndrdnamem.find_by_stndrdname(params[:stnd1]).stndrdcode
        sql = "select distinct shopcode, cmdtycode, stndrdcode1, elementcode1, stndrdcode2, elementcode2, amount, id, stndrdcode, elementcode, disporder, elementname from cmdtystndrdm_stndrdcontentm_views where cmdtycode = '" + @cmdtycode + "' and stndrdcode = '" + stndrdcode + "' order by disporder"
        logd("sql:", sql)
        @cmstcntntview1check = CmdtystndrdmStndrdcontentmView.find_by_sql(sql)
        sql = "select distinct amount, id, stndrdcode, elementcode, disporder, elementname from cmdtystndrdm_stndrdcontentm_views where cmdtycode = '" + @cmdtycode + "' and stndrdcode = '" + stndrdcode + "' order by disporder"
        @cmstcntntview1 = CmdtystndrdmStndrdcontentmView.find_by_sql(sql)
      end
      logd("@cmstcntntview1:", @cmstcntntview1)
      @cmstcntntview2 = []
      if params[:stnd2] != "指定しない"
        stndrdcode = Stndrdnamem.find_by_stndrdname(params[:stnd2]).stndrdcode
        sql = "select distinct shopcode, cmdtycode, stndrdcode1, elementcode1, stndrdcode2, elementcode2, amount, id, stndrdcode, elementcode, disporder, elementname from cmdtystndrdm_stndrdcontentm_views where cmdtycode = '" + @cmdtycode + "' and stndrdcode = '" + stndrdcode + "' order by disporder"
        logd("sql:", sql)
        @cmstcntntview2check = CmdtystndrdmStndrdcontentmView.find_by_sql(sql)
        sql = "select distinct amount, id, stndrdcode, elementcode, disporder, elementname from cmdtystndrdm_stndrdcontentm_views where cmdtycode = '" + @cmdtycode + "' and stndrdcode = '" + stndrdcode + "' order by disporder"
        @cmstcntntview2 = CmdtystndrdmStndrdcontentmView.find_by_sql(sql)
      end
      logd("@cmstcntntview2:", @cmstcntntview2)
      @chkbox = chkbx(@cmstcntntview1, @cmstcntntview2, @cmstcntntview1check, @cmstcntntview2check)
      logd("@chkbox:", @chkbox)
      @stndrdname1 = params[:stnd1]
      @stndrdname2 = params[:stnd2]
      @stndrdcode1 = params[:stndrdcode1]
      @stndrdcode2 = params[:stndrdcode2]
  end

  def chkbx(cmstview1, cmstview2, cmstview1check, cmstview2check)
    cbx = []
    if cmstview1 != nil
      cmstview1.each do |v|
        find = 0
        cmstview1check.each do |c|
          if find == 0
            if v.elementcode == c.elementcode1
              find = 1
              break
            end
          end
        end
        if find == 0
          cbx.push(0)
        else
          cbx.push(1)
        end
      end
    end
    if cmstview2 != nil
      cmstview2.each do |v|
        find = 0
        cmstview2check.each do |c|
          if find == 0
            if v.elementcode == c.elementcode2
              find = 1
              break
            end
          end
        end
        if find == 0
          cbx.push(0)
        else
          cbx.push(1)
        end
      end
    end
    cbx
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
    @cmstcntntview1 = []
    if @cmstnd != []
      sql = "select * from cmdtystndrdm_stndrdcontentm_views where stndrdcode = '" + @cmstnd.first.stndrdcode1 + "' order by disporder"
      logd("sql:", sql)
      @cmstcntntview1 = CmdtystndrdmStndrdcontentmView.find_by_sql(sql)
    end
    logd("@cmstcntntview1:", @cmstcntntview1)
    @cmstcntntview2 = []
    if @cmstnd != []
      sql = "select * from cmdtystndrdm_stndrdcontentm_views where stndrdcode = '" + @cmstnd.first.stndrdcode2 + "' order by disporder"
      logd("sql:", sql)
      @cmstcntntview2 = CmdtystndrdmStndrdcontentmView.find_by_sql(sql)
    end
    @chkbox = chkbx(@cmstcntntview1, @cmstcntntview2)
    logd("@cmstcntntview2:", @cmstcntntview2)
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
