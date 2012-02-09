class CmctgriesController < ApplicationController
  def index
  end

  def edit
    @comdty = Comdty.find(params[:id].to_i)
    #@comdty = Comdty.find(params[:cmdtycode])
    @ctgrymtbls = Ctgrymtbl.all
    $tree = Tree.new
    @name_ary = Array.new
    @ctgcd_ary = Array.new
    @depth = 0

    list_tree
    #$htmlstr = "test"
    
    logd("params[:id]:", params[:id])
    @cmdtyctgries = CmdtyctgryCtgryView.find_by_sql(["select * from cmdtyctgry_ctgry_views where cmdtycode = '" + params[:cmdtycode] + "'"])
    if @cmdtyctgries.first != nil
      logd("@cmdtyctgries.first.ctgryname:", @cmdtyctgries.first.ctgryname)
    end
    
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @comdty }
    end
  end
end
