# Provides the value of the sensor current in amperes.
class CurrentWiFlyProvider < WiFlyProvider

  SENSOR_KEY = "sensor"
  INTERNAL_DIVIDER = "int_divider"
  INTERNAL_ZERO_SHIFT = "int_shift"
  EXTERNAL_DIVIDER = "ext_divider"
  EXTERNAL_ZERO_SHIFT = "ext_shift"
  CURRENT_STEP = "step"

  # Provides current value(in amperes) from sensor.
  def get_sensor_value()
    raw = get_raw_value()
    current = raw_to_current(raw)
    Rails.logger.debug("Current value = #{current}")
    current
  end

  protected

  # Provide raw sensor value
  def get_raw_value()
    Rails.logger.debug("get_sensor for sensor=#{@sensor}")
    begin
      result = get_connector.execute("show q #{@sensor}")
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

  # Init sensor params:
  #   SENSOR_KEY - The WiFly sensor pin interface. Possible values: 0..7.
  #   INTERNAL_DIVIDER - The coefficient of internal resistor divider of WiFly module.
  #   EXTERNAL_DIVIDER - External voltage divider "Hall Sensor": "WiFly pin interface".
  #   INTERNAL_ZERO_SHIFT - The value of the input voltage sensor at 0 volts. Scale in uV.
  #   EXTERNAL_ZERO_SHIFT - The value of the output voltage of hall sensor. Scale in mV.
  #   CURRENT_STEP - voltage step on the sensor Hall. Scale in mV.
  def init
    super
    @sensor = get_config(SENSOR_KEY)
    @external_divider = get_config(EXTERNAL_DIVIDER);
    @internal_divider = get_config(INTERNAL_DIVIDER);
    @external_zero_shift = get_config(EXTERNAL_ZERO_SHIFT);
    @internal_zero_shift = get_config(INTERNAL_ZERO_SHIFT);
    @current_step = get_config(CURRENT_STEP);
  end

  # Converts raw sensor value to current value.
  def raw_to_current(raw)
    sensor_voltage_uv = (raw - @internal_zero_shift.to_f)*@internal_divider.to_f
    hall_voltage_uv = sensor_voltage_uv*@external_divider.to_f - @external_zero_shift.to_f
    (hall_voltage_uv != nil) ? hall_voltage_mv = (hall_voltage_uv / 1000).to_i : hall_voltage_mv = 0
    current = (hall_voltage_mv / @current_step.to_f).round(2)
    return current
  end

end