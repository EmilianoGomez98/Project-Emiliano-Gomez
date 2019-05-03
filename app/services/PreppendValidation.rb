module Preppendvalidation

#Available return codes
# 0 => "STORED"
# 1 => "CLIENT_ERROR:Bad command format "
# 2 => "CLIENT_ERROR:Bad data chunk "
# 3 => "NOT_STORED"
# 4 => "EXISTS"
# 5 => "NOT_FOUND"
# 6 => "ERROR"


  def preppend_valid?(key,bytes,value)
    if !any_empty?([key,bytes])
      if (key.gsub(/\W/,"")==key and bytes.gsub(/\D/,"")==bytes)
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
    return 6
  end



end
