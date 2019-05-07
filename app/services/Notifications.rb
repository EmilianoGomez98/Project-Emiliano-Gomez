class Notifications
  @@messagesHash = {
     0 => "STORED",
     1 => "CLIENT_ERROR: Bad format",
     2 => "CLIENT_ERROR: Bad data chunk ",
     3 => "NOT_STORED",
     4 => "EXISTS",
     5 => "NOT_FOUND",
     6 => "ERROR"
  }

  def self.get_error(statusCode)
    return @@messagesHash[statusCode]
  end

end
