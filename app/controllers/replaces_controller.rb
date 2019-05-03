class ReplacesController < ApplicationController
  include Validation

  def replace
  end

  def create
    if(params.except(:value).values.count { |x| x.blank? } == 0) and replace_is_valid?(params[:key],params[:bytes].to_i,params[:value])
      if !Memdata.is_expired?(params[:key])
        @data = Memdata.new(params[:flag],params[:timeToLive],params[:bytes],params[:value])
        Memdata.set_key(params[:key],@data)
        render '/pages/storage_success'
      else
        Memdata.delete_expired(params[:key])
        redirect_to replace_path, :flash => { :error => "NOT_STORED: Requirements not met" }
      end
    else
      redirect_to replace_path, :flash => { :error => "NOT_STORED: Requirements not met" }
    end
  end


end
