class CounterWiFlyProvider < WiFlyProvider

  GET_COUNTER_COMMAND = 'get_counter'
  RESET_COUNTER_COMMAND = 'reset_counter'
  RESET_COUNTER_SUCCESS = 'OK'
  COUNTER_FACTOR = 'factor'
  SERIAL_NUMBER = 'serial_number'

  # Return a counter value.
  def get_value
    raw_result = get_connector.uart(@get_value)
    int_result = raw_result.strip.to_i
    (@counter_factor != nil) ? result = int_result*@counter_factor.to_f : result = int_result
    logger.debug("Counter raw value=#{raw_result}, result=#{result}")
    return result
  end

  # Return a counter value.
  def reset()
    result = get_connector.uart(@get_value)
    if (result.include? RESET_COUNTER_SUCCESS)
      return true
    end
    return false
  end

  # Provide counter serial number.
  def get_sn
    sn = get_config(SERIAL_NUMBER)
    sn = sn != nil ? sn : 'Unknown'
    sn
  end

  # Init UART config.
  def init
    super
    @get_value = get_config(GET_COUNTER_COMMAND)
    @reset_value = get_config(RESET_COUNTER_COMMAND)
    @counter_factor = get_config(COUNTER_FACTOR)
  end

end