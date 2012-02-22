class CmdtystndrdmsController < ApplicationController
  def index
    logd("come to CmdtystndrdmsController:", "")
    @cmdtycode = ""
    @cmdtyname = ""
    if params[:cmdtycode] != nil
      @cmdtycode = params[:cmdtycode]
      @cmdtyname = params[:cmdtyname]
    end
    sql = "select stndrdcode1, stndrdcode2 from cmdtystndrdm_stndrdcontentm_views where cmdtycode = '" + @cmdtycode + "'"
    logd("sql:", sql)
    logd("@cmdtyname:", @cmdtyname)
    @cmstnd = CmdtystndrdmStndrdcontentmView.find_by_sql(sql)
    logd("@cmstnd:", @cmstnd)
    stndrdname1 = Stndrdnamem.new
    stndrdname2 = Stndrdnamem.new
    if @cmstnd != []
      stndrdname1 = Stndrdnamem.find_by_stndrdcode(@cmstnd.first.stndrdcode1)
      stndrdname2 = Stndrdnamem.find_by_stndrdcode(@cmstnd.first.stndrdcode2)
    end
    logd("stndrdname1.stndrdname:", stndrdname1.stndrdname)
    logd("stndrdname2:", stndrdname2)
    @stndrdname1 = Stndrdnamem.new
    @stndrdname2 = Stndrdnamem.new
    if stndrdname1 != nil && stndrdname1.stndrdname != nil
      @stndrdname1 = stndrdname1.stndrdname
    else
      @stndrdname1 = ""
    end
    if stndrdname2 != nil && stndrdname2.stndrdname != nil
      @stndrdname2 = stndrdname2.stndrdname
    else
      @stndrdname2 = ""
    end
    logd("@stndrdname1:", @stndrdname1)
    logd("@stndrdname2:", @stndrdname2)
    @stndrdcontentm1 = []
    if @cmstnd != []
      sql = "select * from stndrdcontentms where stndrdcode = '" + @cmstnd.first.stndrdcode1 + "' order by disporder"
      logd("sql:", sql)
      @stndrdcontentm1 = Stndrdcontentm.find_by_sql(sql)
    end
    @stndrdcontentm2 = []
    logd("@stndrdcontentm1:", @stndrdcontentm1)
    if @cmstnd != []
      sql = "select * from stndrdcontentms where stndrdcode = '" + @cmstnd.first.stndrdcode2 + "' order by disporder"
      logd("sql:", sql)
      @stndrdcontentm2 = Stndrdcontentm.find_by_sql(sql)
    end
    logd("@stndrdcontentm2:", @stndrdcontentm2)
  end
end
