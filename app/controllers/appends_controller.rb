class AppendsController < ApplicationController
  include Validation

  def append
  end

  def create
    statusCode = append_is_valid?(params[:key],params[:bytes],params[:value])
    if statusCode==0
      @data = Memdata.get_data(params[:key])
      previous_value = @data.value
      @data.value=(previous_value + params[:value])
      @data.bytes=(@data.bytes + params[:bytes].to_i)
      @data.change_casToken
      Memdata.set_key(params[:key],@data)
      render '/pages/storage_success'
    else
      error = Constants.get_error(statusCode)
      redirect_to append_path, :flash => { :error => error }
    end
  end


end
