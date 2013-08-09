class AddDeviceIcon < ActiveRecord::Migration
  def change
    add_column :devices, :icon, :binary
  end
end
