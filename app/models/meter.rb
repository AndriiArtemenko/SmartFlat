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
      counter_value_ = counter.get_value
      result = diff_value.to_f + counter_value_.to_f
      result = result.round(3)
      Rails.logger.debug("meter_value=#{result}")
    rescue => exception
      raise IOError, "Provider access error: #{counter.name}"
      result = Status::UNKNOWN
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

  # Hash of meter state.
  def get_hash
    result = super()
    result['counter_value'] = meter_value.to_s
    result['serial_number'] = "CH5656"
    result
  end

end