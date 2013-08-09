class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :value
      t.datetime :date

      t.timestamps
    end
  end
end
