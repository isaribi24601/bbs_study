require 'sinatra'
require 'sqlite3'
require 'active_record'
require 'json'

ActiveRecord::Base.establish_connection(
"adapter" => "sqlite3",
"database" => "./db/bbs.db"
)
after do
  ActiveRecord::Base.connection.close
end

class Comment < ActiveRecord::Base
end



get '/' do
  @comments = Comment.order('id desc')
  erb :index
  #コメント取得
end

post '/comment' do
  #コメントをDBに保存
  user_id = "Unknown"

  if params[:user_id]
    user_id = params[:user_id]
  end

  Comment.create({
    body: params[:body],
    user_id: user_id
    })
end

get '/comment/last' do
  #最新のコメントをクライアントに返す
  comment = Comment.last
  {comment_body: comment.body, user_id: comment.user_id}.to_json
end
