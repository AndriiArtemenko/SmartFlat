class AddProvider < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
      t.timestamps
    end

    create_table :provider_configs do |t|
      t.belongs_to :provider
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
