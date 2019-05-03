class ReplacesController < ApplicationController
  include Validation
  include Replacevalidation

  def replace
  end

  def create
    statusCode= replace_valid?(params[:key],params[:bytes],params[:flag],params[:timeToLive],params[:value])
    if statusCode ==0
      @data = Memdata.new(params[:flag],params[:timeToLive],params[:bytes],params[:value])
      Memdata.set_key(params[:key],@data)
      render '/pages/storage_success'
    else
      error = Constants.get_error(statusCode)
      redirect_to replace_path, :flash => { :error => error }
    end
  end


end
