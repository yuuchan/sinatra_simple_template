require 'sinatra'
require 'sqlite3'

db = SQLite3::Database.new "test.db"
db.results_as_hash = true

get '/' do
  posts = db.execute("SELECT * FROM posts ORDER BY id DESC")
  erb :example, { :locals => { :posts => posts } }
end

post '/' do
  p params
  stmt = db.prepare("INSERT INTO posts (body) VALUES (?)")
  stmt.bind_params(params["text"])
  stmt.execute
  redirect '/'
end
