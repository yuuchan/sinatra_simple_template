require 'sinatra'
require 'sqlite3'
require 'pp'
require 'securerandom'

db = SQLite3::Database.new "test.db"
db.results_as_hash = true

get '/' do
  posts = db.execute("SELECT * FROM posts ORDER BY id DESC")
  erb :example, { :locals => { :posts => posts } }
end

post '/' do
  pp params
  if params["file"]
  	ext = ""
  	if params["file"][:type].include? "jpeg"
  	  ext = "jpg"
  	elsif params["file"][:type].include? "png"
  	  ext = "png"
  	else
  	  return "error"
    end
    file_name = "#{SecureRandom.hex}.#{ext}"
    save_path = "./public/img/#{file_name}"
    File.open(save_path,'wb') do |f|
  	  f.write params["file"][:tempfile].read
    end
  end
  stmt = db.prepare("INSERT INTO posts (title, body, updated) VALUES (?, ?, datetime('now', '+09:00:00'))")
  stmt.bind_params(params["title"], params["text"])
  stmt.execute
  redirect '/'
end
