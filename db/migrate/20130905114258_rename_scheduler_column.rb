class RenameSchedulerColumn < ActiveRecord::Migration
  def change
    rename_column :schedulers, :performable_id, :schedulable_id
    rename_column :schedulers, :performable_type, :schedulable_type
  end
end
