class Boiler < Device
  has_one :switcher, :as => :receiver, :class_name => 'SwitchWiFlyProvider'
  has_one :current_sensor, :as => :receiver, :class_name => 'CurrentWiFlyProvider'
  has_one :temperature_sensor, :as => :receiver, :class_name => 'TemperatureWiFlyProvider'

  # Get complex device status
  # Result:
  #   Device::ON - Device is on
  #   Device::OFF - Device is off
  #   Device::UNKNOWN - Remote device status unknown
  def remote_status
    Rails.logger.debug("Get remote_status")
    begin
      status = switcher.switched?
      (status == true) ? result = Status::ON : result = Status::OFF
      Rails.logger.debug("result = #{result}")
    rescue => exception
      Rails.logger.info("remote_status error: \n = #{exception}")
      result = Status::UNKNOWN
    end
    result
  end

  # Set complex device status
  def remote_status=(value)
    if value == Status::ON
      switcher.switch_on
    elsif value == Status::OFF
      switcher.switch_off
    end
  end

  # Return temperature of boiler water.
  def get_temperature
    Rails.logger.debug("get_temperature")
    result = Status::UNKNOWN
    begin
      result = temperature_sensor.get_value
      Rails.logger.debug("result = #{result}")
    rescue => exception
      Rails.logger.info("get_temperature error: \n = #{exception}")
    end
    result
  end

  # Return current of boiler supply.
  def get_current
    Rails.logger.debug("get_current")
    result = Status::UNKNOWN
    begin
      result = current_sensor.get_sensor_value
      Rails.logger.debug("result = #{result}")
    rescue => exception
      Rails.logger.info("get_current error: \n = #{exception}")
    end
    result
  end

  def after_save_callback
    self.remote_status = status
  end

  # Watchdog  method for maintain remote status in actual state.
  def perform
    remote = remote_status
    current = status
    if remote != current
      Rails.logger.info("#{self.class.to_s} lost status: remote=#{remote}, current=#{current}")
      after_save_callback
    end
  end
end
