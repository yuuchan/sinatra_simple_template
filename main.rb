require 'sinatra'
require 'sqlite3'
require 'securerandom'

db = SQLite3::Database.new "test.db"
db.results_as_hash = true

get '/' do
  posts = db.execute("SELECT * FROM posts ORDER BY id DESC")
  erb :example, { :locals => { :posts => posts } }
end

post '/' do
  file_name = ""
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
    stmt = db.prepare("INSERT INTO posts (username, title, body, filename, updated) VALUES (?, ?, ?, ?, datetime('now', '+09:00:00'))")
    stmt.bind_params(params["username"], params["title"], params["text"], file_name)
    stmt.execute
    redirect '/'
  else
    return "画像が必要です。"
  end
end
