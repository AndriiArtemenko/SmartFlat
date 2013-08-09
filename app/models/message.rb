class Message < ActiveRecord::Base
  belongs_to :device
  
  def sensors
    logger.debug("PINGG: #{WiflyUtils.rawToSensors(value)}")
    WiflyUtils.rawToSensors(value)
  end
  
end
