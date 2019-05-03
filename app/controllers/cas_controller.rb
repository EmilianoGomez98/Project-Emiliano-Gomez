class CasController < ApplicationController
  include Casvalidation
  include Validation

  def cas
  end

  def create
    statusCode = cas_valid?(params[:key],params[:bytes],params[:flag],params[:timeToLive],params[:value],params[:casToken])
    if statusCode == 0
        @data = Memdata.new(params[:flag],params[:timeToLive],params[:bytes],params[:value])
        Memdata.set_key(params[:key],@data)
        render '/pages/storage_success'
    else
      error = Constants.get_error(statusCode)
      redirect_to cas_path, :flash => { :error => error}
    end
  end

end
