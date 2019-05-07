class ReplacesController < ApplicationController
  include Validation
  include Replacevalidation

  def replace
  end

  def create
    statusCode= replace_valid?(params[:key],params[:bytes],params[:flag],params[:timeToLive],params[:value])
    notification = Constants.get_error(statusCode)
    if statusCode ==0
      @data = Memdata.new(params[:flag],params[:timeToLive],params[:bytes],params[:value])
      Memdata.set_key(params[:key],@data)
      redirect_to root_path, :flash => {:notice => notification}
    else
      redirect_to replace_path, :flash => { :error => notification }
    end
  end


end
