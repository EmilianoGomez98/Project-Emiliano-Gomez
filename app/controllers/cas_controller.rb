class CasController < ApplicationController
  include Validation

  def cas
  end

  def create
    statusCode = cas_is_valid?(params[:key],params[:bytes],params[:value],params[:timeToLive],params[:casToken].to_i)
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
