class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.integer :message_template_id
      t.string :message_template_type
      t.integer :device_id
      t.string :device_type

      t.timestamps
    end
  end
end
