class CreatePurchases < ActiveRecord::Migration
  def self.up
    create_table :purchases do |t|
      t.integer :wallet_id
      t.integer :amount
      t.integer :user_id
      t.decimal :value, :precision => 8, :scale => 2
      t.datetime :purchased_at

      t.timestamps
    end
  end

  def self.down
    drop_table :purchases
  end
end
