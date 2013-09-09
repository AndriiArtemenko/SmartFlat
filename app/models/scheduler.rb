class Scheduler < ActiveRecord::Base
  belongs_to :schedulable, :polymorphic => true

  def text_shift
    result = shifts_hash[shift]
  end

  def text_shift=(value)
    shifts_hash = shifts_hash.key(value)
  end

  def next_alarm
    current_alarm = alarm.clone
    step = mask
    case shift
      when 1 then
        sec = step.sec
        current_alarm = alarm_gain(current_alarm, :seconds => sec)
      when 2 then
        min = step.min
        current_alarm = alarm_gain(current_alarm, :minutes => min)
      when 3 then
        hr = step.hour
        current_alarm = alarm_gain(current_alarm, :hours => hr)
      when 4 then
        year = step.year
        current_alarm = alarm_gain(current_alarm, :years => year)
      when 5 then
        month = step.month
        current_alarm = alarm_gain(current_alarm, :months => month)
      when 6 then
        day = step.day
        current_alarm = alarm_gain(current_alarm, :days => day)
      else current_alarm = Time.now
    end
    current_alarm
  end

  protected

  # Increases date before the time has not come yet
  def alarm_gain(alarm, step)
    while(alarm < Time.now)
      alarm = alarm.advance(step)
    end
    alarm
  end

  # Symbolic shifts names
  def shifts_hash
    result = Hash.new()
    result[1] = 'Sec'
    result[2] = 'Min'
    result[3] = 'Hr'
    result[4] = 'Day'
    result[5] = 'Mon'
    result[6] = 'Year'
    result
  end
end
