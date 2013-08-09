class CurrentWiFlyProvider < WiFlyProvider

  SENSOR_KEY = "sensor"

  #
  # TODO: Sensor must returns sensor value
  #
  # Provide sensor value
  def get_sensor_value()
    Rails.logger.debug("get_sensor for sensor=#{@sensor}")
    begin
      result = get_connector.execute("show q")
    rescue => exception
      Rails.logger.info("Execution failure:\n #{exception}")
    end

    if (result != nil) && (result.include? WiflyNames::CMD_PROMT)
      Rails.logger.debug("promt given")
      startPosition = result.index(WiflyNames::CMD_PROMT)
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

  # Init sensor) mask.
  def init
    super
    @sensor = get_config(SENSOR_KEY)
  end

end