class ChangePostBody < ActiveRecord::Migration
    def self.up
      change_column :posts, :body, :text
    end

    def self.down
      change_column :posts, :body, :string
    end
end
