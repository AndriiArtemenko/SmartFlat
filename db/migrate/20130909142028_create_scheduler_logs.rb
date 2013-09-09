class CreateSchedulerLogs < ActiveRecord::Migration
  def change
    create_table :scheduler_logs do |t|
      t.belongs_to :scheduler
      t.text :scheduler_log
      t.timestamps
    end
  end
end
