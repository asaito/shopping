class CmdtystndrdmsController < ApplicationController
  def index
    if params[:cmdtycode] != nil
      @cmdtycode = params[:cmdtycode]
    end
  end

end
