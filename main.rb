require "sinatra"
require "sinatra/activerecord"
require "sinatra/reloader"
require "sinatra/flash"
enable :sessions

set :database, "sqlite3:microblog.db"
require "./models"

get "/" do
	if session[:user_id]
    puts "logged in"
  else
    puts "NOT logged in!"
  end

	erb :index
end

get "/signup" do

	erb :signup 
end

post "/signup" do
	@user = User.create(email: params[:email], password: params[:password])
	flash[:notice] = "You have successfully registered. Please log in."
	redirect "/"
end

get "/login" do

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

get "/profile" do

	erb :profile
end

get "/logout" do
	session[:user_id] = nil
	redirect "/"

	erb :logout
end

get "/editprofile" do
	def current_user 
		if session[:user_id]
			@current_user = User.find(session[:user_id])
		end
	end

	"this is edit profile"

	erb :editprofile	
end

post "/editprofile" do
	@user = current_user.update_attributes(email: params[:email], password: params[:password])
	redirect "/editprofile"

	erb :editprofile	
end

