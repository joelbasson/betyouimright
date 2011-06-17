class CreateBetCategories < ActiveRecord::Migration
  def self.up
    create_table :bet_categories do |t|
      t.string :name
      t.timestamps
    end
    add_column :bets, :bet_category_id, :integer
    add_index :bets, :bet_category_id
  end

  def self.down
    drop_table :bet_categories
    remove_column :bets, :bet_category_id
    remove_index :bets, :bet_category_id
  end
end
