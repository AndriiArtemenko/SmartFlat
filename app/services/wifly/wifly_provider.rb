require 'singleton'

class WiflyProvider
  include Singleton
  
  CONNECTION_HOST = "192.168.1.105"
  CONNECTION_PORT = 2000

  CMD_OK = "AOK"
  CMD_PROMT = "<2.38.3>"

  ON_MASK = 0xFFFF
  OFF_MASK = 0x0

  #constructor
  #init connector
  def initialize
    @wiflyConnector = nil
    @wiflyConnector = WiflyConnector.new("192.168.1.105", "2000")
  end

  # Set port value by mask
  # portMask, value values - see on WiflyNames
  def setPort(portMask, value)
    Rails.logger.debug("setPort #{portMask} started.")
    begin
      result = @wiflyConnector.execute("set sys output #{value} #{portMask}")
    rescue => exception
      Rails.logger.info("Execution failure:\n #{exception}")
    end

    if (result != nil) && (result.include? CMD_OK)
      Rails.logger.debug("Seted sucess.")
      true
    else
      Rails.logger.debug("Invocation failure!")
      false
    end
  end

  # Get port value by mask
  # portMask values - see on WiflyNames
  def getPort(portMask)
    Rails.logger.debug("getPort #{portMask} started.")
    begin
      result = @wiflyConnector.execute("show io")
    rescue => exception 
      Rails.logger.info("Execution failure:\n #{exception}")
    end

    if (result != nil) && (result.include? CMD_PROMT)
      Rails.logger.debug("promt given #{result}")
      startPosition = result.index(CMD_PROMT)
      if startPosition > 0
        Rails.logger.debug("Start position is #{startPosition}")
        begin
          value = result[startPosition-4, 3].hex
          value = (value & portMask)>0 ? WiflyNames::PORT_ON : WiflyNames::PORT_OFF
        rescue => exception
          Rails.logger.info("Convertation error:\n #{exception}")
          value nil
        end
        Rails.logger.debug("value=#{value}")
        value
      else
        Rails.logger.debug("Position not found")
        nil
      end  
    else 
      Rails.logger.debug("Invocation failure!")
      nil
    end  
  end

  # Get sensor value
  # sensor values - see on WiflyNames
  def getSensor(sensor)
    Rails.logger.debug("getSensor #{sensor}")
    begin
      result = @wiflyConnector.execute("show q")
    rescue => exception 
      Rails.logger.info("Execution failure:\n #{exception}")
    end

    if (result != nil) && (result.include? CMD_PROMT)
      Rails.logger.debug("promt given")
      startPosition = result.index(CMD_PROMT)
      if startPosition > 0
        Rails.logger.debug("Start position is #{startPosition}")
        begin
          value = result[startPosition-7, 5].hex
        rescue => exception
          Rails.logger.info("Execution failure:\n #{exception}")
          value=nil
        end
        value
      else   
        Rails.logger.debug("Start position is not found")
        nil
      end
    else
      Rails.logger.debug("Invocation failure!")
      nil
    end
  end


  def self.connect

  end
  
  #attr_accessor :sensor, :output;
  def sensor
    @sensor
  end
  
  def sensor=(value)
    #stub
    #@sensor = value
  end
  
  def output
    @output
  end
  
  def output=(value)
    #stub
    @output = value
  end
  
  def self.getSensorsValues(raw)
    WiflyUtils.rawToSensors(raw)
  end
end