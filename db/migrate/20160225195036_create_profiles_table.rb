class CreateProfilesTable < ActiveRecord::Migration
  def change
  	create_table :profiles do |table|
  		table.string :username
  		table.string :about
  		table.string :picture
  		table.integer :user_id
  	end
  end
end
