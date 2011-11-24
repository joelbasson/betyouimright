class AddJudgeToBets < ActiveRecord::Migration
  def change
    add_column :bets, :judge_id, :integer
  end
end
