class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.string :title
      t.text :message
      t.integer :user_id
      t.boolean :viewed, :default => false
      t.boolean :closed, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
