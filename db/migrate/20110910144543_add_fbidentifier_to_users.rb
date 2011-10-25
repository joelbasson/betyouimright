class AddFbidentifierToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fbidentifier, :string
  end
end
