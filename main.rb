require "sinatra"
require "sinatra/activerecord"
require "sinatra/reloader"
require "sinatra/flash"
enable :sessions

set :database, "sqlite3:microblog.db"
require "./models"

def current_user 
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	else
		redirect "/"
	end
end


get "/" do
	@title_text = "I <3 Pizza"

	if session[:user_id]
		puts "logged in"
  	else
    	puts "NOT logged in!"
  	end

  	@posts = Post.all
  	@last_ten_posts = Post.last(10)

	erb :index
end


get "/signup" do
	@title_text = "Sign up for Pizza"
	erb :signup 
end

post "/signup" do
	@user = User.create(username: params[:username], email: params[:email], password: params[:password])
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

end

get "/profile" do

  @user = current_user
  @posts = current_user.posts

	erb :profile	
end

# get "profile/:id"
# erb :profile	
# end

post "/profile" do
	@user = current_user

	@timestamp = Time.now.strftime("%Y-%m-%d")

	@post = Post.create(user_id: session[:user_id], body: params[:body], posttime: @timestamp)
	
	redirect "/profile"

	erb :profile
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

	@post = Post.create(user_id: session[:user_id], body: params[:body], posttime: @timestamp)

	redirect "/homepage"
end


get "/posts/:id/delete" do
	@post = Post.find(params[:id]) 

	if @post.user_id == session[:user_id]
		@post.destroy
		flash[:notice] = "Your post has been deleted."
		redirect "/homepage"
	else
		flash[:alert] = "This is not your post!"
		redirect "/homepage"
	end
end

get "/editprofile" do

	erb :editprofile
end

post "/editprofile" do
	user = current_user

	@user = current_user.update_attributes(email: params[:email])
	@user = current_user.update_attributes(password: params[:password])
	@user = current_user.update_attributes(username: params[:username])
	@user = current_user.update_attributes(about: params[:about])
	@user = current_user.update_attributes(picture: params[:picture])

	redirect "/editprofile"

end


get "/profile/:id" do 

	if session[:user_id] == nil
    redirect "/"
  	end

 end

get "/users" do
	if session[:user_id] == nil

		redirect "/"
	end

	@users = User.all

	erb :users
end









