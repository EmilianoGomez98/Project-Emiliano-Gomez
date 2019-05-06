class GetsController < ApplicationController

  def get
  end

  def show
    keys= params[:keys].split(/\W+/)
    if !keys.blank?
      @dataHash = Hash.new
      keys.each do |key|
        if Memdata.has_key?(key)
          if !Memdata.is_expired?(key)
            @dataHash[key]=(Memdata.get_data(key))
          else
            Memdata.delete_expired(key)
          end
        end
      end
    else
      redirect_to get_path, :flash => { :error => "ERROR" }
    end
  end

end
