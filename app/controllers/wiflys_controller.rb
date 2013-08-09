class WiflysController < ApplicationController
  
  def postSensorsData
    puts "----start----"
    sensors = WiflyProvider.getSensorsValues(params[:id])
    sensors.each do |key|
      puts "sensor #{key}"
      begin
        config = WiflyConfig.find(:first, :conditions => {:subtype => "sensor_event", :name => "#{key[0]}"})
      rescue
        puts "Error #{$!}"
        config = nil
      end        
 
      # if (false)
        # config = WiflyConfig.new
        # config.subtype = "sensor_event"
        # config.name = "2"
        # config.value = "2"
        # config.save        
      # end 
      
      if config != nil   
        deviceId = config.value
        puts "device id = #{deviceId}" 
        begin
          device = Device.find(deviceId) 
        rescue
          device = nil
          puts "Error #{$!}"
        end
               
        if device != nil
          puts "#{device.class}"
          device.sensorEvennt(key[0], key[1])
        end
      end
      puts "" 
    end
    
    redirect_to :action => "list"
  end
  
  def showSensorsData
    #@message = Message.find(params[:id])
    @messages = Message.all
  end
  
  
end
