class AddBetToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :bet_id, :integer
  end

  def self.down
    remove_column :topics, :bet_id
  end
end
