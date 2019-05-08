class PreppendsController < ApplicationController
  include Ppendvalidation
  include Auxvalidation

  def prepend
  end

  def create
    statusCode = ppend_valid?(params[:key],params[:bytes],params[:value])
    notification = Notifications.get_error(statusCode)
    if statusCode==0
      @data = Memdata.get_data(params[:key])
      previous_value = @data.value
      @data.value=(params[:value] + previous_value)
      @data.bytes=(@data.bytes + params[:bytes].to_i)
      @data.change_casToken
      redirect_to root_path, :flash => {:notice => notification}
    else
      redirect_to preppend_path, :flash => { :error => notification }
    end
  end

end
