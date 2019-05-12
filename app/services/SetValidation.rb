module Setvalidation

  #Available return codes
  # 0 => "STORED",
  # 1 => "CLIENT_ERROR:Bad command format ",
  # 2 => "CLIENT_ERROR:Bad data chunk ",
  # 3 => "NOT_STORED",
  # 4 => "EXISTS",
  # 5 => "NOT_FOUND"
  # 6 => "ERROR"

  def set_valid?(key,bytes,flag,timeToLive,value)
    if !any_empty?([key,bytes,flag,timeToLive])
      if (key.gsub(/\W/,"")==key and bytes.gsub(/\D/,"")==bytes and timeToLive.gsub(/\D/,"")==timeToLive and flag.gsub(/\D/,"")==flag)
        if bytes.to_i==value.length
          return 0
        end
        return 2
      end
      return 1
    end
    return 6
  end



end
