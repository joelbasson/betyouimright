class AddFbfriendscollectionToUser < ActiveRecord::Migration
  def change
    remove_column :users, :fbfriendscollection
    add_column :users, :fbfriendscollection, :text
  end
end
