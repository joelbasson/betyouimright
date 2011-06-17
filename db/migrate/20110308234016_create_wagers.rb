class CreateWagers < ActiveRecord::Migration
  def self.up
    create_table :wagers do |t|
      t.integer :user_id
      t.integer :bet_id
      t.boolean :against, :default => false
      t.integer :credits, :default => 10

      t.timestamps
    end
  end

  def self.down
    drop_table :wagers
  end
end
