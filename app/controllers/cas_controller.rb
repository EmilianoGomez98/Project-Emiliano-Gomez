class CasController < ApplicationController
  include Casvalidation
  include Validation

  def cas
  end

  def create
    statusCode = cas_valid?(params[:key],params[:bytes],params[:flag],params[:timeToLive],params[:value],params[:casToken])
    notification = Constants.get_error(statusCode)
    if statusCode == 0
        @data = Memdata.new(params[:flag],params[:timeToLive],params[:bytes],params[:value])
        Memdata.set_key(params[:key],@data)
        redirect_to root_path, :flash => {:notice => notification}
    else
      redirect_to cas_path, :flash => { :error => notification}
    end
  end

end
