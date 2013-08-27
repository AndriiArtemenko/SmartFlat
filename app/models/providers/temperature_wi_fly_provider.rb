class TemperatureWiFlyProvider < WiFlyProvider

  GET_TEMP_COMMAND = "get_temperature"
  FRACTIONAL_MASK = 0x000F;
  INTEGER_MASK = 4;

  # Return a raw sensor temperature value.
  def get_raw_value
    result = get_connector.uart(@get_value)
    return result.strip.to_i
  end

  # Return a temperature value.
  def get_value
    raw_temperature = get_raw_value;
    integer = raw_temperature >> INTEGER_MASK;
    fractional = (raw_temperature & FRACTIONAL_MASK)*10/16;
    temperature = integer.to_s + '.' + fractional.to_s;
  end

  # Read provider config.
  def init
    super
    @get_value = get_config(GET_TEMP_COMMAND)
  end

end