class ChangeReciverIndex < ActiveRecord::Migration
  def up
    remove_index :providers, :name =>"index_providers_on_receiver_type_and_receiver_id"
  end

  def down
    add_index :providers, [:receiver_type, :receiver_id]
  end
end
