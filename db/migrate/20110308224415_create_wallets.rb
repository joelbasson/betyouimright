class CreateWallets < ActiveRecord::Migration
  def self.up
    create_table :wallets do |t|
      t.integer :credits
      t.integer :user_id
      t.integer :score, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :wallets
  end
end
