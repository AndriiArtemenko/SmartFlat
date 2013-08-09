class RenameColumnWiflyconfig < ActiveRecord::Migration
  def change
    rename_column :wifly_configs, :type, :subtype
  end

end
