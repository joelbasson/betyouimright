class AddVisibilityToBet < ActiveRecord::Migration
  def change
    add_column :bets, :visibility, :string
  end
end
