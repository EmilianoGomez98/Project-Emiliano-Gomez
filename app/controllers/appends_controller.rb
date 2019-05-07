class AppendsController < ApplicationController
  include Appendvalidation
  include Validation


  def append
  end

  def create
    statusCode = append_valid?(params[:key],params[:bytes],params[:value])
    notification = Constants.get_error(statusCode)
    if statusCode==0
      @data = Memdata.get_data(params[:key])
      previous_value = @data.value
      @data.value=(previous_value + params[:value])
      @data.bytes=(@data.bytes + params[:bytes].to_i)
      @data.change_casToken
      Memdata.set_key(params[:key],@data)
      redirect_to root_path, :flash => {:notice => notification}
    else
      redirect_to append_path, :flash => { :error => notification }
    end
  end


end
