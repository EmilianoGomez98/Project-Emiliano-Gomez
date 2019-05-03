module Validation

#timeToLive tiene que ser dígito
###Idea: Tener boton 'Refresh' en menu inicio
#####Sacar método 'is_expired?' de 'add_is_valid', ponerlo afuera, para que se pueda usar 'delete_expired' IMPORTANTE
######Unir 'getcas' y 'gets', para poder usar un solo show. meter 3 metodos en un controller
#######Checkear mensajes de error en cas_controller
########Separar metodos valid
#########Append no puede estar vacio bytes y value



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


  def append_is_valid?(key,bytes,value)
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
