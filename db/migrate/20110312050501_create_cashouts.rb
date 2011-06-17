class CreateCashouts < ActiveRecord::Migration
  def self.up
    create_table :cashouts do |t|
      t.integer :wallet_id
      t.integer :amount
      t.string :paypal_email
      t.decimal :value
      t.string :return_message
      t.integer :user_id
      t.datetime :completed_at
      t.timestamps
    end
  end

  def self.down
    drop_table :cashouts
  end
end
