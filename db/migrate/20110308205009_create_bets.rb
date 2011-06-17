class CreateBets < ActiveRecord::Migration
  def self.up
    create_table :bets do |t|
      t.string :title
      t.text :description
      t.datetime :end_date
      t.integer :wager_amount
      t.text :verify_description
      t.boolean :verified, :default => false
      t.boolean :confirmed, :default => false
      t.string :status, :default => "Undecided"
      t.integer :user_id
      t.integer :wagers_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :bets
  end
end
