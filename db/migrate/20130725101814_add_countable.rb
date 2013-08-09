class AddCountable < ActiveRecord::Migration
  def up
    create_table :counters do |t|
      t.integer :countable_id
      t.string :countable_type
      t.integer :start_value
      t.integer :current_value
    end

    add_index :counters, [:countable_type, :countable_id], :unique => true
  end

  def down
  end
end
