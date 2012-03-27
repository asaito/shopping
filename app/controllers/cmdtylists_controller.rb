class CmdtylistsController < ApplicationController
  def index
    if params[:ctgrycode]
      dispcmdties
    else
      disp_allcmdties
    end
    $tree = Tree.new
    @name_ary = Array.new
    @ctgcd_ary = Array.new
    @depth = 0
    $from_cmdtylists = 1
    
    list_tree

  end

  def dispcmdties
    sql = "select * from cmdty_ctgry_views where ctgrycode = \'" + params[:ctgrycode] + "\'"
    logd("sql:", sql)
    @cmdties = CmdtyCtgryView.find_by_sql(sql) 
    logd("cmdties.first.cmdtyname:", @cmdties.first.cmdtyname)
  end
  def disp_allcmdties
    sql = "select distinct(cmdtycode), cmdtyname, description, unitprice, bannerfile, bannerurl from cmdty_ctgry_views"
    @cmdties = CmdtyCtgryView.find_by_sql(sql) 
    logd("sql:", sql)
  end

end
