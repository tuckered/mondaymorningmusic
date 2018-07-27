require 'sinatra/reloader'
require 'sinatra'
require 'pg'    
require 'httparty'


def run_sql(sql)
  conn = PG.connect(dbname: 'mondaymusic')
  result = conn.exec(sql)
  conn.close
  return result
end



require_relative 'db_config'
require_relative 'models/song'
require_relative 'models/comment'
require_relative 'models/user'
require_relative 'models/like'

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

  def has_liked?(song_id)
    Like.where(user_id: current_user.id, song_id: song_id).any?
  end

  def artwork(artist, title)
    @artwork = HTTParty.get('http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=57ee3318536b23ee81d6b27e36997cde&artist=' + artist + '&track=' + title + '&format=json')['track']['album']['image'][3]["#text"]
  end

  def album_title(artist, title)
    @album_title = HTTParty.get('http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=57ee3318536b23ee81d6b27e36997cde&artist=' + artist + '&track=' + title + '&format=json')['track']['album']['title']
  end


  def track_check(artist, title) 
    @track_check = HTTParty.get('http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=57ee3318536b23ee81d6b27e36997cde&artist=' + artist + '&track=' + title + '&format=json')
  end


end


get '/' do
  @song = Song.all
  erb :index
end

get '/songs/new' do
  erb :new
end

get '/playlist' do
  @user = current_user
  @like = Like.all
  erb :playlist
end

get '/songs/:id' do
  @song = Song.find(params[:id])
  @comments = @song.comments
  erb :song_details
end


post '/songs' do
  @song = Song.new
  @song.title = params[:title]
  @song.artist = params[:artist]
  
  track_check(params[:artist], params[:title].gsub(' ', '+'))
  if @track_check['message'] == "Track not found"
    redirect 'songs/new'
  end
  
  @song.song_url = params[:song_url]
  @song.album = album_title(params[:artist], params[:title].gsub(' ', '+'))
  @song.artwork_url = artwork(params[:artist], params[:title].gsub(' ', '+'))

  # if @song.artwork_url['track']['album']['image'][3]["#text"] == ("")
  #   @song.artwork_url = '/stylesheets/headphones-placeholder.jpeg'
  # else
  @song.user_id = current_user.id
  @song.save
  redirect '/'
    # end
end

delete '/songs/:id' do
  song = Song.find(params[:id])
  song.destroy
  redirect "/"
end

get '/songs/:id/edit' do
  @song = Song.find(params[:id])
  erb :edit
end


put '/songs/:id' do
  @song = Song.find(params[:id])
  @song.title = params[:title]
  @song.artist = params[:artist]
  @song.album = params[:album]
  @song.song_url = params[:song_url]
  @song.artwork_url = artwork(params[:artist], params[:title])
  @song.save
  redirect "/songs/#{ params[:id] }"
end


post '/comments' do
  redirect '/login' unless logged_in?
  comment = Comment.new
  comment.content = params[:content]
  comment.song_id = params[:song_id]
  comment.user_id = current_user.id
  comment.username = current_user.username
  comment.save
  redirect "/songs/#{ params[:song_id] }"
end


get '/register' do
  erb :register
end

post '/register' do
  @user = User.new
  @user.password = (params[:password])
  @user.username = (params[:username])
  @user.email = (params[:email])

  if @user.save
    session[:user_id] = @user.id
    redirect '/'
  else 
    erb :register
    # redirect '/register'
  end

end


get '/login' do
  erb :login
end


post '/session' do
 
  @user = User.find_by(username: params[:username])
  if @user && @user.authenticate(params[:password])
    session[:user_id] = @user.id
    redirect '/'
  else
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end


post '/likes' do
  redirect '/login' unless logged_in?

  # current_activity = Activity.find(params[:activity_id])
  like_count = current_user.likes.where(user_id: current_user.id).length
  like = Like.new
  like.song_id = params[:song_id]
  like.user_id = current_user.id
  like.username = current_user.username
  like.save
  redirect "/songs/#{params[:song_id]}"
end


delete '/likes' do
  like = Like.where(user_id: current_user.id).where(song_id: params[:song_id]).first
  like.destroy
  redirect "/songs/#{params[:song_id]}"
end

