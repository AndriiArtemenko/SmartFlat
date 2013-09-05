class RenameScheduler < ActiveRecord::Migration
  def change
    rename_column :schedulers, :object_id, :performable_id
    rename_column :schedulers, :object_type, :performable_type
  end
end
