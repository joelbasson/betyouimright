class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :transactions, :wallet_id
    add_index :transactions, :bet_id
    add_index :wagers, :user_id
    add_index :wagers, :bet_id
    add_index :comments, :user_id
    add_index :cashouts, :wallet_id
    add_index :cashouts, :user_id
    add_index :bets, :user_id
    add_index :payment_notifications, :transaction_id
    add_index :payment_notifications, :purchase_id
    add_index :users, :wallet_id
    add_index :purchases, :wallet_id
    add_index :purchases, :user_id
  end

  def self.down
  end
end
