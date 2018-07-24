require 'sinatra/reloader'     
require 'sinatra'
require 'pg'    


def run_sql(sql)
  conn = PG.connect(dbname: 'mondaymusic')
  result = conn.exec(sql)
  conn.close
  return result
end

require_relative 'db_config'
require_relative 'models/song'
require_relative 'models/user'
require_relative 'models/comment'

enable :sessions


helpers do 

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    if current_user
      return true
    else
      return false
    end
  end  
end


get '/' do
  @songs = Song.all
  erb :index
end

get '/songs/new' do
  erb :new
end

get '/playlist' do
  @songs = Song.all
  erb :playlist
end

get '/songs/:id' do
  @song = Song.find(params[:id])
  @comments = @song.comments
  erb :song_details
end

post '/songs' do
  song = Song.new
  song.title = params[:title]
  song.artist = params[:artist]
  song.album = params[:album]
  song.song_url = params[:song_url]
  song.artwork_url = params[:artwork_url]
  song.user_id = current_user.id
  song.save
  redirect '/'
end

delete '/songs/:id' do
  song = Song.find(params[:id])
  song.destroy
  redirect "/"
end

get '/songs/:id/edit' do
  @songs = Song.find(params[:id])
  erb :edit
end


put '/songs/:id' do
  song = Song.find(params[:id])
  song.title = params[:title]
  song.artist = params[:artist]
  song.album = params[:album]
  song.song_url = params[:song_url]
  song.artwork_url = params[:artwork_url]
  song.save
  redirect "/songs/#{ params[:id] }"
end

post '/comments' do
  redirect '/login' unless logged_in?

  comment = Comment.new
  comment.content = params[:content]
  comment.song_id = params[:song_id]
  comment.user_id = current_user.id
  comment.save
  redirect "/songs/#{ params[:song_id] }"
end




get '/register' do
  erb :register
end

post '/register' do
  user = User.new
  user.username = (params[:username])
  user.password = (params[:password])
  user.save
  redirect "/"
end


get '/login' do
  erb :login
end


post '/session' do
  user = User.find_by(username: params[:username])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/login'
end


