require "sinatra"
require "sinatra/activerecord"
require "sinatra/reloader"

set :database, "sqlite3:microblog.db"


get "/" do
	"hello guys"
end