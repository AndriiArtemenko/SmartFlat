class ReportDeviceRelation < ActiveRecord::Migration
  def change
    remove_column :reports, :device_id
    remove_column :reports, :device_type

    create_table :reports_devices do |t|
      t.belongs_to :report
      t.belongs_to :device
    end
  end
end
