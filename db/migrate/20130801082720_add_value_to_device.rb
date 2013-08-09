class AddValueToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :custom_value, :string
  end
end
