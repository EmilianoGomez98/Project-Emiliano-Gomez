module Auxvalidation


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




end
