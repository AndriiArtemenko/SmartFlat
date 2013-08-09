class RenameCountable2 < ActiveRecord::Migration
  def up
    rename_table :counter, :meter
  end

  def down
  end
end
