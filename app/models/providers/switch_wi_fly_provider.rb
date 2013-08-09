class SwitchWiFlyProvider < WiFlyProvider

  GPIO_KEY = "gpio"

  # Sets port(s) to mask value.
  def set_port(port, mask)
    Rails.logger.debug("set_port for port=#{port} mask=#{mask}.")
    begin
      result = get_connector.execute("set sys output #{port} #{mask}")
    rescue => exception
      Rails.logger.info("Execution failure:\n #{exception}")
    end

    if (result != nil) && (result.include? WiflyNames::CMD_OK)
      Rails.logger.debug("Value was successfully set.")
      true
    else
      Rails.logger.debug("Port setting failure!")
      false
    end
  end

  # Get port value by mask
  # portMask values - see on WiflyNames
  def get_port(port)
    Rails.logger.debug("get_port for port=#{port}.")
    begin
      result = get_connector.execute("show io")
    rescue => exception
      Rails.logger.info("Execution failure:\n #{exception}")
    end

    if (result != nil) && (result.include? WiflyNames::CMD_PROMT)
      Rails.logger.debug("promt given #{result}")
      startPosition = result.index(WiflyNames::CMD_PROMT)
      if startPosition > 0
        Rails.logger.debug("Start position is #{startPosition}")
        begin
          value = result[startPosition-4, 3].hex
          Rails.logger.debug("value = #{value}")
          result = value & port
          if (result == 0)
            return WiflyNames::PORT_OFF
          elsif (result == port)
            return WiflyNames::PORT_ON
          end
        rescue => exception
          Rails.logger.info("Convertation error:\n #{exception}")
        end
      else
        Rails.logger.debug("Position not found")
      end
    else
      Rails.logger.debug("Invocation failure!")
    end
    nil
  end

  # Switch devise to value.
  def switch(value)
    result = false
    if @gpio != nil
      begin
        result = set_port(@gpio, value)
      rescue => exception
        result = false
      end
    end
    result
  end

  # Switch on device.
  def switch_on
    switch(WiflyNames::PORT_ON)
  end

  # Switch off device.
  def switch_off
    switch(WiflyNames::PORT_OFF)
  end

  # Check device for on/off
  def switched?
    status = get_port(@gpio)
    if status == nil
      raise(IOError, "Unknown port value!")
    end

    if status = WiflyNames::PORT_ON
      true
    elsif status = WiflyNames::PORT_OFF
      false
    end
  end

  # Init port(s) mask.
  def init
    super
    @gpio = get_config(GPIO_KEY)
  end

end