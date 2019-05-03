module Validation


# 0 => "STORED",
# 1 => "CLIENT_ERROR:Bad command format ",
# 2 => "CLIENT_ERROR:Bad data chunk ",
# 3 => "NOT_STORED",
# 4 => "EXISTS",
# 5 => "NOT_FOUND"
# 6 => "ERROR"

def any_empty?(arr)
  arr.each do |var|
    if var.strip.blank?
      return true
    end
  end
  return false
end


  def preppend_is_valid?(key,bytes,value)
    if (key.index(" ")==nil and bytes.gsub(/\D/,"")==bytes)
      if bytes.to_i>=value.length
        if Memdata.has_key?(key)
          if !Memdata.is_expired?(key)
            return 0
          end
          Memdata.delete_expired(key)
          return 3
        end
        return 3
      end
      return 2
    end
    return 1
  end


  def cas_is_valid?(key,bytes,value,timeToLive,casToken)
    if key.index(" ")==nil and bytes.gsub(/\D/,"")==bytes and timeToLive.gsub(/\D/,"")==timeToLive
      if bytes.to_i>=value.length
        if Memdata.has_key?(key)
          if !Memdata.is_expired?(key)
            data = Memdata.get_data(key)
            if data.casToken==casToken
              return 0
            end
            return 4
          end
          Memdata.delete_expired(key)
          return 3
        end
        return 3
      end
      return 2
    end
    return 1
  end




end
