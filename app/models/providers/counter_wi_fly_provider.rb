class CounterWiFlyProvider < WiFlyProvider

  GET_COUNTER_COMMAND = 'get_counter'
  RESET_COUNTER_COMMAND = 'reset_counter'
  RESET_COUNTER_SUCCESS = 'OK'

  # Return a counter value.
  def get_value
    result = get_connector.uart(@get_value)
    return result.strip.to_i
  end

  # Return a counter value.
  def reset()
    result = get_connector.uart(@get_value)
    if (result.include? RESET_COUNTER_SUCCESS)
      return true
    end
    return false
  end

  # Init UART config.
  def init
    super
    @get_value = get_config(GET_COUNTER_COMMAND)
    @reset_value = get_config(RESET_COUNTER_COMMAND)
  end

end