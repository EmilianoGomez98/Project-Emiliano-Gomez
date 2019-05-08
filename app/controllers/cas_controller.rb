class CasController < ApplicationController
  include Casvalidation
  include Auxvalidation

  def cas
  end

  def create
    statusCode = cas_valid?(params[:key],params[:bytes],params[:flag],params[:timeToLive],params[:value],params[:casToken])
    notification = Notifications.get_error(statusCode)
    if statusCode == 0
        Memdata.create_memdata(params[:key],params[:flag],params[:timeToLive],params[:bytes],params[:value])
        redirect_to root_path, :flash => {:notice => notification}
    else
      redirect_to cas_path, :flash => { :error => notification}
    end
  end

end
