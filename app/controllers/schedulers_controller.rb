class SchedulersController < ApplicationController

  # Get all schedulers.
  def list
    @schedulers = Scheduler.all
    @provider_list = [SwitchWiFlyProvider.to_s, CurrentWiFlyProvider.to_s, CounterWiFlyProvider.to_s]
    logger.debug("Show schedulers list : #{@schedulers}")
  end

  # Get scheduler by id.
  def edit
    @scheduler = Scheduler.find(params[:id])
  end

  def start_scheduler
    current = Time.now
    tasks = Hash.new

    # Update alarm time and prepare list of tasks.
    Scheduler.where("alarm <= ?", current).all.each do |scheduler|
      logger.info("Alarm \"#{scheduler.name}\" at #{scheduler.alarm}")
      scheduler.alarm = scheduler.next_alarm
      scheduler.save
      logger.info("Next \"#{scheduler.name}\" alarm at #{scheduler.alarm}")
      if (scheduler.schedulable != nil)
        puts "Task #{scheduler.name} found."
        tasks[scheduler.name] = scheduler
      end
    end

    # Start tasks from list.
    tasks.each { |key, value|
      logger.info("Start task #{key}")
      result = value.schedulable.perform
      log = SchedulerLog.new()
      log.scheduler = value
      log.scheduler_log = result
      value.scheduler_logs << log
      value.save
      logger.info("done")
    }

    render nothing: true
  end

end
