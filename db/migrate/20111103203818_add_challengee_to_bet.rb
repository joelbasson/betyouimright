class AddChallengeeToBet < ActiveRecord::Migration
  def change
    add_column :bets, :challengee_id, :integer
  end
end
