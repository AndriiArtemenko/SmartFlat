class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :pin
      t.string :offset

      t.timestamps
    end
  end
end
