class AddCounterCacheToBets < ActiveRecord::Migration
  def self.up
    add_column :bets, :comments_count, :integer, :default => 0

    say_with_time("Adding counter-cache counts to all bets") do
      Bet.reset_column_information
      Bet.find(:all).each do |b|
        Bet.update_counters b.id, :comments_count => b.comments.length
      end
    end
      
  end

  def self.down
    remove_column :bets, :comments_count
  end
end
