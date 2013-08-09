class WiflyUtils

  SENSOR_OFFSET = 2458;
  NULL_VALUE = 3646;               
  INTERNAL_DEVIDER = 5.7;
  EXTERNAL_DEVISER = 13.43;
  AC_ADJUSTMENT = 1.414;
  CURRENT_FACTOR = 66000;

  # Try conver hex to dec
  # return nil on problem
  #
  def self.hexToInt(value)
    if value != nil
    begin
      value.to_i(16)
    rescue  
      nil
    end        
    else   
      nil
    end
  end
  
  def self.sensorToCurrent(sensor)
    if sensor != nil
      (((sensor - NULL_VALUE)*16*INTERNAL_DEVIDER*AC_ADJUSTMENT*EXTERNAL_DEVISER)/CURRENT_FACTOR).round(3).abs*220    
    end
  end

  # Conver sensor raw data to hash list of dec values 
  # Sample:
  # 'FFFF00001111222233334444555566667777' =>
  #  {0=>"FFFF", 1=>"0000", 2=>"1111", 3=>"2222", 4=>"3333", 5=>"4444", 6=>"5555", 7=>"6666", 8=>"7777"} 
  #
  def self.rawToSensors(raw)
    sensors = Hash.new
    if raw != nil      
      sensors[0] = sensorToCurrent(hexToInt(raw[0, 4]))
      sensors[1] = sensorToCurrent(hexToInt(raw[4, 4]))
      sensors[2] = sensorToCurrent(hexToInt(raw[8, 4]))
      sensors[3] = sensorToCurrent(hexToInt(raw[12, 4]))
      sensors[4] = sensorToCurrent(hexToInt(raw[16, 4]))
      sensors[5] = sensorToCurrent(hexToInt(raw[20, 4]))
      sensors[6] = sensorToCurrent(hexToInt(raw[24, 4]))
      sensors[7] = sensorToCurrent(hexToInt(raw[28, 4]))
      sensors[8] = sensorToCurrent(hexToInt(raw[32, 4]))    
      sensors     
    end
  end	

end