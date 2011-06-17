class CreateAuthentications < ActiveRecord::Migration
  def self.up
    remove_column :users, :rpx_identifier
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.timestamps
    end
  end

  def self.down
    drop_table :authentications
  end
end
