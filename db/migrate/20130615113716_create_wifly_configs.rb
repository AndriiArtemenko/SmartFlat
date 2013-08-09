class CreateWiflyConfigs < ActiveRecord::Migration
  def change
    create_table :wifly_configs do |t|
      t.string :type
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
