class AddFbtokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :fbtoken, :string
    add_column :users, :fbfriendscollection, :string
    add_column :users, :fbtoken_updated_at, :string
  end
end
