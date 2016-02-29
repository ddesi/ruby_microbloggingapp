class CreateUsersTable < ActiveRecord::Migration
  def change
  	create_table :users do |table|
  		table.string :email
  		table.string :password
  		table.string :username
  		table.string :about
  		table.string :picture
  	end
  end
end
