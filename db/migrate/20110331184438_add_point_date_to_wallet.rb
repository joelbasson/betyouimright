class AddPointDateToWallet < ActiveRecord::Migration
  def self.up
    add_column :wallets, :pointtime, :datetime, :default => 6.hours.from_now
  end

  def self.down
    remove_column :wallets, :pointtime
  end
end
