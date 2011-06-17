class RemoveDisplayNameFromBet < ActiveRecord::Migration
  def self.up
    remove_column :bets, :display_name
    add_column :cashouts, :return_message, :string
  end

  def self.down
  end
end
