# -*- encoding: utf-8 -*-
class StndrdcontentmsController < ApplicationController
  def index
    @msg = ""
    @stndrdcontentms = Stndrdcontentm.find_by_sql("select * from stndrdcontentms where stndrdcode = '" + "s1" + "' order by stndrdcode asc")

    line_no = @stndrdcontentms.size
    if params['add_image.x'] != nil && params['add_image.x'].to_i > 0
      stndrdcontentm = Stndrdcontentm.new
      stndrdcontentm.shopcode = 1
      stndrdcontentm.stndrdcode = "s1"#params[:elementcodeNew]
      stndrdcontentm.elementcode = params[:elementcodeNew]
      stndrdcontentm.elementname = params[:elementnameNew]
      stndrdcontentm.disporder = params[:disporderNew]
      if stndrdcontentm.elementname =="" || stndrdcontentm.disporder == ""
	@msg = "文字が入力されていません。"
      else
	stndrdcontentm.save
	@msg = "登録しました。"
      end
    elsif params[:upd_image] != nil
      i = 0
      while i < line_no.to_i
        if params[:upd_image][i.to_s] != nil
          stndrdcontentm =Stndrdcontentm.find_by_id(params[:stndrdcontentid][i.to_s])
	  stndrdcontentm.stndrdcode = "s1"
	  stndrdcontentm.elementcode = params[:elementcode][i.to_s]
	  stndrdcontentm.elementname = params[:elementname][i.to_s]
	  stndrdcontentm.disporder = params[:disporder][i.to_s]
	  if stndrdcontentm != nil
	    if stndrdcontentm.elementcode == "" || stndrdcontentm.elementname =="" || stndrdcontentm.disporder == ""
	      @msg = "文字が入力されていません。"
	    else
	      stndrdcontentm.save
	      @msg = "更新しました。"
	    end
	  end
	  break
	end
	i += 1
      end
    elsif params[:del_image] != nil
      i = 0
      while i < line_no.to_i
	logd("params[:del_image][i.to_s]:", params[:del_image][i.to_s])
        if params[:del_image][i.to_s] != nil
	  logd("params[:stndrdcontentid][i.to_s]:", params[:stndrdcontentid][i.to_s])
          stndrdcontentm =Stndrdcontentm.find_by_id(params[:stndrdcontentid][i.to_s])
	  sql = "select * from cmdtystndrdms where (stndrdcode1 = '" + "s1" + "' and elementcode1 = '" + params[:elementcode][i.to_s] + "') or (stndrdcode2 = '" + "s1" + "' and elementcode2 = '" + params[:elementcode][i.to_s] + "')" 
	  logd("sql:", sql)
	  cmdtystndrdm = Cmdtystndrdm.find_by_sql(sql)
	  logd("stndrdcontentm:", stndrdcontentm)
	  logd("cmdtystndrdm:", cmdtystndrdm)
	  logd("cmdtystndrdm.size:", cmdtystndrdm.size)
	  if cmdtystndrdm.size > 0
            @msg = "商品に紐づけられていますので削除できません。"
          elsif stndrdcontentm != nil && cmdtystndrdm != nil && cmdtystndrdm.size == 0
            stndrdcontentm.destroy
            @msg = "削除しました。"
          end
          break
        end
        i += 1
      end
    end

    @stndrdcontentms = Stndrdcontentm.find_by_sql("select * from stndrdcontentms where stndrdcode = '" + "s1" + "' order by stndrdcode asc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stndrdcontentms }
    end
  end

end
