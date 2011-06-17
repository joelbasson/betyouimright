class AwardWallets < ActiveRecord::Migration
  def self.up
    create_table :awards_wallets, :id => false  do |t|
      t.integer :award_id
      t.integer :wallet_id

      t.timestamps
    end
    
    add_index(:awards_wallets, [:award_id, :wallet_id], :unique => true)
  end

  def self.down
    drop_table :awards_wallets
  end
end
