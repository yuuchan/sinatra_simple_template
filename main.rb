require 'sinatra'
require 'sqlite3'

db = SQLite3::Database.new "test.db"
db.results_as_hash = true

get '/' do
  posts = db.execute("SELECT * FROM posts ORDER BY id DESC")
  erb :example, { :locals => { :posts => posts } }
end

get '/example' do
  erb :example
end
