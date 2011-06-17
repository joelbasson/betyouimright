class CreateBonuses < ActiveRecord::Migration
  def self.up
    create_table :bonuses do |t|
      t.string :name
      t.string :short_description
      t.text :description
      t.string :rule
      t.text :rule_description
      t.string :activation
      t.integer :credits, :default => 0
      t.integer :target, :default => 0
      t.string :beneficiary, :default => "Winners"
      t.string :bonustype, :default => "WagersTotal"
      t.timestamps
    end
  end

  def self.down
    drop_table :bonuses
  end
end
