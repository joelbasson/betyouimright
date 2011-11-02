class AddFbtokenUpdateAtTpUsers < ActiveRecord::Migration
  def change
    remove_column :users, :fbtoken_updated_at
    add_column :users, :fbtoken_updated_at, :datetime
  end
end
