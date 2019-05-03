class GetcasController < ApplicationController

  def getcas
  end

  def show
    keys= params[:keys].split(/\W+/)
    @dataHash = Hash.new
    for i in 0..keys.length
      if Memdata.has_key?(keys[i])
        if !Memdata.is_expired?(keys[i])
          @dataHash[keys[i]]=(Memdata.get_data(keys[i]))
        else
          Memdata.delete_expired(keys[i])
        end
      end
    end
  end

end
