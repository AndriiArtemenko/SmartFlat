class AddDeviceToProviderRelation < ActiveRecord::Migration
  def change
    add_column :providers, :receiver_id, :integer
    add_column :providers, :receiver_type, :string

    add_index :providers, [:receiver_type, :receiver_id], :unique => true
  end
end
