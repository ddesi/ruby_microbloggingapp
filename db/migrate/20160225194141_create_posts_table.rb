class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts do |table|
  		table.integer :user_id
  		table.string :body
  	end
  end
end
