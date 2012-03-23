class CmdtylistsController < ApplicationController
  def index
    #@comdty = Comdty.find($cmdtyid.to_i)
    $tree = Tree.new
    @name_ary = Array.new
    @ctgcd_ary = Array.new
    @depth = 0
    $from_cmdtylists = 1

    list_tree

  end

end
