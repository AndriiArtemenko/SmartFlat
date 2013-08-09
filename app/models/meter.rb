class Meter < Device
  has_one :counter, :as => :receiver, :class_name => 'CounterWiFlyProvider'

  # Return start value for counter.
  def diff_value
    custom_value
  end

  # Sets start value for counter.
  def diff_value=(value)
    custom_value = value
  end

  # Return diff plus counter values
  # as full counter value
  def meter_value
    begin
      result = diff_value + counter.get_value
      Rails.logger.debug("meter_value=#{result}")
    rescue => exception
      raise IOError, "Provider access error: #{counter.name}"
    end
    result
  end

  # Init new meter value
  def meter_value=(value)
    diff_value = meter_value
    begin
      counter.reset
    rescue => exception
      raise IOError, "Provider access error: #{counter.name}"
    end
  end

  # Return meter value ready for display.
  def meter_state
    begin
      result = meter_value
    rescue => exception
      Rails.logger.info("#{exception}")
      result = Status::UNKNOWN
    end
  end

end