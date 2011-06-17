class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :wallet_id
      t.string :description
      t.integer :bet_id

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
