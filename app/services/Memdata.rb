class Memdata

  attr_accessor :flag, :bytes, :value
  attr_reader :casToken, :expTime
  @@keyHash = {}
  @@casCounter = 1

  def initialize(flag,timeToLive,bytes,value)
    @flag = flag
    @bytes = bytes.to_i
    @value = value
    timeToLive = timeToLive.to_i
    if (timeToLive>0)
      @expTime = Time.now +  timeToLive.seconds
    elsif (timeToLive==0)
      @expTime = nil
    else
      @expTime = Time.now
    end
    @casToken = @@casCounter
    @@casCounter +=1
  end

  def self.create_memdata(key,flag,timeToLive,bytes,value)
    data = Memdata.new(flag,timeToLive,bytes,value)
    @@keyHash[key] = data
  end

  def change_casToken
    @casToken = @@casCounter
    @@casCounter +=1
  end

  def self.is_expired?(key)
    time = Time.now.to_i
    expTime = @@keyHash[key].expTime
    if(expTime!=nil)
      return (@@keyHash.has_key?(key) and expTime.to_i<=time)
    end
    return false
  end

  def self.delete_expired(key)
    @@keyHash.delete(key)
  end

  def self.get_data(key)
    return @@keyHash[key]
  end

  def self.has_key?(key)
    return (@@keyHash.has_key?(key))
  end

end
