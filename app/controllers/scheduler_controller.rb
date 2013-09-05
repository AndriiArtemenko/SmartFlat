class SchedulerController < ApplicationController

  def start_scheduler
    current = Time.now
    tasks = Hash.new

    # Update alarm time and prepare list of tasks.
    Scheduler.where("alarm <= ?", current).all.each do |scheduler|
      logger.info("Alarm \"#{scheduler.name}\" at #{scheduler.alarm}")
      next_alarm = calc_next(scheduler)
      scheduler.alarm = next_alarm
      scheduler.save
      logger.info("Next \"#{scheduler.name}\" alarm at #{next_alarm}")
      if (scheduler.schedulable != nil)
        puts "Task #{scheduler.name} found."
        tasks[scheduler.name] = scheduler.schedulable
      end
    end

    # Start tasks from list.
    tasks.each {
      |key, value|
      puts "Start task #{key}"
      value.perform
      puts "done"
    }

    render nothing: true
  end

  private

  # Increases date before the time has not come yet
  def alarm_gain(alarm, step)
    while(alarm < Time.now)
      alarm = alarm.advance(step)
    end
    alarm
  end

  # Calculates the time of the next event
  def calc_next(schedule)
    if (schedule != nil)
      alarm = schedule.alarm.clone
      step = schedule.mask
      case schedule.shift
        when 1 then
          sec = step.sec
          alarm = alarm_gain(alarm, :seconds => sec)
        when 2 then
          min = step.min
          alarm = alarm_gain(alarm, :minutes => min)
        when 3 then
          hr = step.hour
          alarm = alarm_gain(alarm, :hours => hr)
        when 4 then
          year = step.year
          alarm = alarm_gain(alarm, :years => year)
        when 5 then
          month = step.month
          alarm = alarm_gain(alarm, :months => month)
        when 6 then
          day = step.day
          alarm = alarm_gain(alarm, :days => day)
        else alarm = Time.now
      end
      alarm
    end
  end
end
