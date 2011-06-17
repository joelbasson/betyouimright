class AddCounterCache < ActiveRecord::Migration
  def self.up
    add_column :comments, :comments_count, :integer, :default => 0

    say_with_time("Adding counter-cache counts to all comments") do
      Comment.reset_column_information
      Comment.find(:all).each do |c|
        Comment.update_counters c.id, :comments_count => c.comments.length
      end
    end
      
  end

  def self.down
    remove_column :comments, :comments_count
  end
end
