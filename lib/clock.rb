require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

module Clockwork

  BOILER_JOB ='boiler.job'

  configure do |config|
    config[:tz] = "Europe/Kiev"
  end

  handler do |job|
    if (job == BOILER_JOB)
      boiler = Boiler.find(2)
      if (boiler != nil)
        boiler.perform
      end
    end
  end

  every(1.minutes, BOILER_JOB)
  #every(10.seconds, 'frequent.job')
  #every(3.minutes, 'less.frequent.job')
  #every(1.hour, 'hourly.job')
  #every(1.day, 'midnight.job', :at => '00:00')
  #every(1.minutes, 'test', :if => lambda { |t| t.sec == 9 })
end