class ReplacesController < ApplicationController
  include Replacevalidation
  include Auxvalidation

  def replace
  end

  def create
    statusCode= replace_valid?(params[:key],params[:bytes],params[:flag],params[:timeToLive],params[:value])
    notification = Notifications.get_error(statusCode)
    if statusCode ==0
      @data = Memdata.new(params[:flag],params[:timeToLive],params[:bytes],params[:value])
      Memdata.set_key(params[:key],@data)
      redirect_to root_path, :flash => {:notice => notification}
    else
      redirect_to replace_path, :flash => { :error => notification }
    end
  end


end
