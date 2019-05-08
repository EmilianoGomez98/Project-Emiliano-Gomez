class SetsController < ApplicationController
  include Setvalidation
  include Auxvalidation

  def set
  end

  def create
    statusCode = set_valid?(params[:key],params[:bytes],params[:flag],params[:timeToLive],params[:value])
    notification = Notifications.get_error(statusCode)
    if statusCode==0
        Memdata.create_memdata(params[:key],params[:flag],params[:timeToLive],params[:bytes],params[:value])
      redirect_to root_path, :flash => {:notice => notification}
    else
      redirect_to set_path, :flash => { :error => notification }
    end
  end


end
