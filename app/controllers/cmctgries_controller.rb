class CmctgriesController < ApplicationController
  def index
  end

  def edit
    @comdty = Comdty.find(params[:cmdtycode])
  end
end
