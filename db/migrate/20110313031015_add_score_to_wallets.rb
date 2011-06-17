class AddScoreToWallets < ActiveRecord::Migration
  def self.up
    add_column :wallets, :score, :integer, :default => 0
  end

  def self.down
  end
end
