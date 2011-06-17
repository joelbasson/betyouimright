class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id
      t.text :body
      t.integer :commentable_id
      t.string :commentable_type
      t.boolean :is_spam

      t.timestamps
    end
    
    add_index :comments, [:commentable_id, :commentable_type]
  end

  def self.down
    drop_table :comments
  end
end
