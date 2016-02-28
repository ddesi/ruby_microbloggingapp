require "sinatra"
require "sinatra/activerecord"
require "sinatra/reloader"
require "sinatra/flash"
enable :sessions

set :database, "sqlite3:microblog.db"
require "./models"

get "/" do
	@title_text = "I <3 Pizza"
	if session[:user_id]
    puts "logged in"
  else
    puts "NOT logged in!"
  end

	erb :index
end

get "/signup" do
	@title_text = "Sign up for Pizza"
	erb :signup 
end

post "/signup" do
	@user = User.create(email: params[:email], password: params[:password])
	flash[:notice] = "You have successfully registered. Please log in."
	redirect "/"
end

get "/login" do
	@title_text = "Login to Pizza"
	erb :login
end

post "/login" do

	@user = User.where(email: params[:email]).first
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "You are now signed in."
	redirect "/profile"

	else flash[:alert] = "Invalid credentials. Please try again."
	redirect "/login"
	end

end


get "/logout" do
	session[:user_id] = nil
	redirect "/"

	erb :logout
end

get "/profile" do
	@user = current_user
		def current_user 
			if session[:user_id]
				@current_user = User.find(session[:user_id])
			else
				redirect "/"
		end
	end

	erb :profile	
end

post "/profile" do

	@user = current_user

	# @user = current_user.update_attributes(email: params[:email], password: params[:password])
	# we could try 
	@user.update(email: params[:email], password: params[:password])
	# and see if it works even if you update only one param >> nope haha
	# it only displays the param that you edited once you click on the submit button
	# ... we could have a separate page to edit the profile and redirect to the profile page
	redirect "/profile"

	# erb :profile
end

post "/delete" do
  @user = current_user
  @user.delete
  redirect "/logout"
  # or we could have a flash to confirm the logout and redirect to the homepage??
end


get "/homepage" do
		@posts = Post.all

	erb :homepage
end


post "/homepage" do
	@timestamp = Time.now.strftime("%Y-%m-%d")

	@post = Post.create(body: params[:body], posttime: @timestamp)

	redirect "/homepage"
end

get "/posts/:id/delete" do
  @post = Post.find(params[:id]).destroy
  redirect "/homepage"
end



