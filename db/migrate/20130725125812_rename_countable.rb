class RenameCountable < ActiveRecord::Migration
  def up
      rename_table :counters, :counter
  end

  def down
  end
end
