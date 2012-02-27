# -*- encoding: utf-8 -*-
class CmdtystndrdmsController < ApplicationController
  def index
    getparams
    logd("@cmdtycode:", @cmdtycode)
    @allcheck = 0
    @allrelease = 0
    if params['allsel_image.x'].to_i > 1
      @allcheck = 1
      @allrelease = 0
      srch_display
    elsif params['allrel_image.x'].to_i > 1
      @allcheck = 0
      @allrelease = 1
      srch_display
    elsif params['srch_image.x'].to_i > 0
      srch_display
    elsif params['confirm_image.x'].to_i > 0
      additems, uncheckitems = checkitems
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
      Cmdtystndrdm.where("cmdtycode = ?", @cmdtycode).destroy_all
      if additems != nil
	additems.each do |a|
	  if params[:elementcode1] != nil
	    elementcode1 = params[:elementcode1][a]
	    amount = params[:amount][a].to_i
	  end
	  if params[:elementcode2] != nil
	    elementcode2 = params[:elementcode2][a]
	    amount = params[:amount][a].to_i
	  end
	  cmstd = cmstm(elementcode1, elementcode2, amount)
	  logd("cmstd:", cmstd)
	  cmstd.save
	end
      end
      srch_display
    else
      indexfromcmdty
    end
    @stndrdname_all = stndnamelist(Stndrdnamem.all)
    #logd("Stndrdnamem.all:", Stndrdnamem.all)
    #logd("@stndrdname_all:", @stndrdname_all)
  end

  def cmstm(elementcode1, elementcode2, amount)
    cmst = Cmdtystndrdm.new
    if elementcode1 != "" && elementcode2 != ""
      cmsts = Cmdtystndrdm.where(:cmdtycode => params[:cmdtycode], :stndrdcode1 =>  params[:stndrdcode1], :stndrdcode2 => params[:stndrdcode2])
      alreadyinserted = 0
      cmsts.each do |c|
	if c.elementcode1 == elementcode1 && c.elementcode2 == elementcode2
	  cmst = c
	  alreadyinserted = 1
	  break
	end
      end
      if alreadyinserted == 0
	cmst = Cmdtystndrdm.new
	cmst.shopcode = "1"
	cmst.cmdtycode = params[:cmdtycode]
	cmst.stndrdcode1 = params[:stndrdcode1]
	cmst.stndrdcode2 = params[:stndrdcode2]
	cmst.elementcode1 = elementcode1
	cmst.elementcode2 = elementcode2
      end
      cmst.amount = amount
    elsif elementcode1 != "" && elementcode2 == ""
      cmsts = Cmdtystndrdm.where(:cmdtycode => params[:cmdtycode], :stndrdcode1 =>  params[:stndrdcode1])
      alreadyinserted = 0
      cmsts.each do |c|
        if c.elementcode1 == elementcode1
          cmst = c
          alreadyinserted = 1
          break
        end
      end
      if alreadyinserted == 0
        cmst = Cmdtystndrdm.new
        cmst.shopcode = "1"
	cmst.cmdtycode = params[:cmdtycode]
	cmst.stndrdcode1 = params[:stndrdcode1]
	cmst.stndrdcode2 = ""
	cmst.elementcode1 = elementcode1
	cmst.elementcode2 = ""
      end
      cmst.amount = amount
    elsif elementcode1 == "" && elementcode2 != ""
      cmsts = Cmdtystndrdm.where(:cmdtycode => params[:cmdtycode], :stndrdcode2 =>  params[:stndrdcode2])
      alreadyinserted = 0
      cmsts.each do |c|
        if c.elementcode2 == elementcode2
          cmst = c
          alreadyinserted = 1
          break
        end
      end
      if alreadyinserted == 0
        cmst = Cmdtystndrdm.new
        cmst.shopcode = "1"
	cmst.cmdtycode = params[:cmdtycode]
	cmst.stndrdcode1 = ""
	cmst.stndrdcode2 = params[:stndrdcode2]
	cmst.stndrdcode1 = ""
	cmst.elementcode2 = elementcode2
      end
      cmst.amount = amount
    end
    cmst
  end

  def uncheckitems(chkbox, chkitems)
    unchk = []
    chkboxsize = 0
    if @chkbox == nil
      chkboxsize = params[:chkboxsize].to_i
    else
      chkboxsize = @chkbox.size
    end
    i = 0
    for i in 0..chkboxsize - 1
      find = 0
      logd("i:", i)
      chkitems.each do |ct|
      logd("ct:", ct)
	if ct == i.to_s
	  find = 1
	  break
	end
      end
      logd("find:", find.to_s)
      if find == 0
	unchk.push(i)
      end
      i += 1
    end
    unchk
  end

  def checkitems
      logd("params[:checked_items]:", params[:checked_items])
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
      unchk = uncheckitems(@chkbox, additems)
      logger.debug 'unchk.length:' + unchk.length.to_s
      for i in 0..unchk.length - 1
        logger.debug 'unchk' + '[' + i.to_s + ']:' + unchk[i].to_s
      end
      return additems, unchk
  end

  def srch_display
      logd("params[:stnd1]:", params[:stnd1])
      @stndrdcontent1 = []
      cmstcntntview1check = CmdtystndrdmStndrdcontentmView.new
      sql = "select * from cmdtystndrdms where cmdtycode = '" + @cmdtycode + "'"
      logd("sql11:", sql)
      cmdtystndrdms = Cmdtystndrdm.find_by_sql(sql)
      @cmstcntntview1 = []
      if params[:stnd1] != "指定しない"
        stndrdcode = Stndrdnamem.find_by_stndrdname(params[:stnd1]).stndrdcode
        sql = "select distinct amount, id, stndrdcode, elementcode, disporder, elementname from cmdtystndrdm_stndrdcontentm_views where cmdtycode = '" + @cmdtycode + "' and stndrdcode = '" + stndrdcode + "' order by disporder"
        @cmstcntntview1 = CmdtystndrdmStndrdcontentmView.find_by_sql(sql)
	sql = "select * from stndrdcontentms where stndrdcode = '" + stndrdcode + "' order by disporder"
	logd("sql12:", sql)
	@stndrdcontent1 = Stndrdcontentm.find_by_sql(sql)
      end
      #logd("@cmstcntntview1:", @cmstcntntview1)
      @stndrdcontent2 = []
      @cmstcntntview2 = []
      if params[:stnd2] != "指定しない"
        stndrdcode = Stndrdnamem.find_by_stndrdname(params[:stnd2]).stndrdcode
        sql = "select distinct amount, id, stndrdcode, elementcode, disporder, elementname from cmdtystndrdm_stndrdcontentm_views where cmdtycode = '" + @cmdtycode + "' and stndrdcode = '" + stndrdcode + "' order by disporder"
        @cmstcntntview2 = CmdtystndrdmStndrdcontentmView.find_by_sql(sql)
        sql = "select * from stndrdcontentms where stndrdcode = '" + stndrdcode + "' order by disporder"
	logd("sql13:", sql)
        @stndrdcontent2 = Stndrdcontentm.find_by_sql(sql)
      end
      #logd("@cmstcntntview2:", @cmstcntntview2)
      logd("@stndrdcontent1:", @stndrdcontent1)
      logd("@stndrdcontent2:", @stndrdcontent2)
      logd("cmdtystndrdms:", cmdtystndrdms)
      @chkbox, @amount = chkbx_amount(@stndrdcontent1, @stndrdcontent2, cmdtystndrdms)
      logd("@chkbox:", @chkbox)
      @stndrdname1 = params[:stnd1]
      @stndrdname2 = params[:stnd2]
      @stndrdcode1 = params[:stndrdcode1]
      @stndrdcode2 = params[:stndrdcode2]
      checkitems
  end

  def chkbx_amount(stndrdcontent1, stndrdcontent2, cmdtystndrdms)
    cbx = []
    amount = []
    if stndrdcontent1 != []
      stndrdcontent1.each do |s1|
	if stndrdcontent2 != []
	  stndrdcontent2.each do |s2|
	    find = 0
	    cmdtystndrdms.each do |c|
	      logd("s1.stndrdcode c.stndrdcode1 s1.elementcode c.elementcode1 s2.stndrdcode c.stndrdcode2 c.elementcode c.elementcode2 c.amount:", s1.stndrdcode+" "+c.stndrdcode1+" "+s1.elementcode+" "+c.elementcode1+" "+s2.stndrdcode+" "+c.stndrdcode2+" "+s2.elementcode+" "+c.elementcode2+" "+c.amount.to_s)
	      if s1.stndrdcode == c.stndrdcode1 && s1.elementcode == c.elementcode1 && s2.stndrdcode == c.stndrdcode2 && s2.elementcode == c.elementcode2
		if @allrelease == 1
		  cbx.push(0)
		else
		  cbx.push(1)
		end
		amount.push(c.amount)
		find = 1
		break
	      end
	    end
	    if find == 0
	      if @allcheck == 1
		cbx.push(1)
	      else
		cbx.push(0)
	      end
	      amount.push(0)
	    end
	  end
	else
	  find = 0
	  cmdtystndrdms.each do |c|
	    #logd("s1.stndrdcode c.stndrdcode1 s1.elementcode c.elementcode1 c.stndrdcode2 c.elementcode c.elementcode2 c.amount:", s1.stndrdcode+" "+c.stndrdcode1+" "+s1.elementcode+" "+c.elementcode1+" "+c.stndrdcode2+" "+c.elementcode2+" "+c.amount.to_s)
	    if s1.stndrdcode == c.stndrdcode1 && s1.elementcode == c.elementcode1 
              if @allrelease == 1
                cbx.push(0)
              else
                cbx.push(1)
              end
	      amount.push(c.amount)
	      find = 1
	      break
	    end
	  end
	  if find == 0
            if @allcheck == 1
              cbx.push(1)
            else
              cbx.push(0)
            end
	    amount.push(0)
	  end
	end
      end
    else
      if stndrdcontent2 != []
	stndrdcontent2.each do |s2|
	  find = 0
	  cmdtystndrdms.each do |c|
	    if s2.stndrdcode == c.stndrdcode2 && s2.elementcode == c.elementcode2
              if @allrelease == 1
                cbx.push(0)
              else
                cbx.push(1)
              end
	      amount.push(c.amount)
	      find = 1
	      break
	    end
	  end
	  if find == 0
            if @allcheck == 1
              cbx.push(1)
            else
              cbx.push(0)
            end
	    amount.push(0)
	  end
	end
      end
    end
    return cbx, amount
  end
=begin
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
=end

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
    #logd("@cmstcntntview1:", @cmstcntntview1)
    @cmstcntntview2 = []
    if @cmstnd != []
      sql = "select * from cmdtystndrdm_stndrdcontentm_views where stndrdcode = '" + @cmstnd.first.stndrdcode2 + "' order by disporder"
      logd("sql:", sql)
      @cmstcntntview2 = CmdtystndrdmStndrdcontentmView.find_by_sql(sql)
    end
    #@chkbox = chkbx(@cmstcntntview1, @cmstcntntview2)
    #logd("@cmstcntntview2:", @cmstcntntview2)

    sql = "select * from cmdtystndrdms where cmdtycode = '" + @cmdtycode + "'"
    logd("sql11:", sql)
    cmdtystndrdms = Cmdtystndrdm.find_by_sql(sql)
    sql = "select * from stndrdcontentms where stndrdcode = '" + cmdtystndrdms.first.stndrdcode1 + "' order by disporder"
    logd("sql12:", sql)
    @stndrdcontent1 = Stndrdcontentm.find_by_sql(sql)
    sql = "select * from stndrdcontentms where stndrdcode = '" + cmdtystndrdms.first.stndrdcode2 + "' order by disporder"
    logd("sql13:", sql)
    @stndrdcontent2 = Stndrdcontentm.find_by_sql(sql)
    logd("@stndrdcontent1:", @stndrdcontent1)
    logd("@stndrdcontent2:", @stndrdcontent2)
    @chkbox, @amount = chkbx_amount(@stndrdcontent1, @stndrdcontent2, cmdtystndrdms)
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
