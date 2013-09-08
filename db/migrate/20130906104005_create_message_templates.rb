class CreateMessageTemplates < ActiveRecord::Migration
  def change
    create_table :message_templates do |t|
      t.string :name
      t.string :subject
      t.text :body
      t.string :address
      t.string :type

      t.timestamps
    end
  end
end
