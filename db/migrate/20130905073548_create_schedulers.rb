class CreateSchedulers < ActiveRecord::Migration
  def change
    create_table :schedulers do |t|
      t.string :name
      t.datetime :mask
      t.integer :shift
      t.datetime :alarm
      t.integer :object_id
      t.string :object_type

      t.timestamps
    end
  end
end
