class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts do |table|
  		table.integer :user_id
  		table.string :body
  		table.datetime :posttime
  	end
  end
end
