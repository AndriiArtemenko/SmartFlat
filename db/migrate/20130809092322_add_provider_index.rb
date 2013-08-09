class AddProviderIndex < ActiveRecord::Migration
  def change
    add_index :providers, [:receiver_type, :receiver_id]
  end
end
