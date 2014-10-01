require 'sinatra/base'
require_relative 'game'

class BattleShips < Sinatra::Base

  GAME = Game.new

  enable :sessions
  set :session_secret, "I'm starting with the man in the mirror"
  set :views, Proc.new {File.join(root, '..', "views")}
  set :public_dir, Proc.new {File.join(root, '..', "public")}
  
  get '/' do
    session[:player] = ''
    erb :index
  end

  get '/begin' do
    erb :begin
  end

  post '/begin' do
     GAME.add_player(Player.new(params[:player]))
     session[:player] = params[:player]
     redirect '/launch' if GAME.players.count == 2
     redirect '/wait'
  end

  get '/wait' do
    redirect '/launch' if GAME.players.count == 2
    erb :wait
  end

  get '/launch' do
    erb :launch
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
