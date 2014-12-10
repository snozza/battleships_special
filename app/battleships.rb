require 'sinatra/base'
require 'rack-flash'
require 'securerandom'

require_relative '../lib/game'
require_relative 'helpers/application'

class BattleShips < Sinatra::Base

  enable :sessions
  use Rack::Flash, :sweep => true
  set :session_secret, "super secret"
  set :public_dir, Proc.new {File.join(root, '..', "public")}

  include Helpers

  @@games = Hash.new
  @@waiting_player = []

  get '/' do
    if @@waiting_player.empty?
      session[:id] = SecureRandom.uuid
      @@waiting_player << session[:id]
      @@games[session[:id]] = Game.new
    else
      session[:id] = SecureRandom.uuid
      @@games[session[:id]] = @@games[@@waiting_player.pop]
    end
    erb :index

  end

  get '/begin' do
    erb :begin
  end

  post '/begin' do
    if params[:player] == ""
      flash[:error] = "Need to enter a name"
      redirect '/begin'
    end
    player = name_converter(params[:player])
    if name_used?(player)
      flash[:error] = "Name already in use"
      redirect '/begin'
    end 
    add_player(player)
    session[:player] = player
    redirect "/deploy" if game_ready?
    redirect '/wait'
  end

  get '/wait' do
    redirect "/deploy" if game_ready?
    erb :wait
  end

  get '/deploy' do 
    player = player_select(session[:player])
    @current_player = player.name
    @display_name = get_name(player)
    @opponent = get_name(find_opponent(player))
    @board = player.board
    @next_ship = player.ships.first
    erb :deploy
  end

  post '/deploy' do 
    if params[:coordinate] == "" || params[:direction] == ""
      flash[:error] = "You need to enter a coordinate and a direction"
      redirect "/deploy"
    end
    coordinate = receive_coord(params[:coordinate])
    direction = params[:direction]
    player = player_select(session[:player])
    ship = player.ships.first
    if !placement_check(ship, coordinate, direction, player)
      flash[:error] = "Invalid placement!"; redirect "/deploy"
    end
    
    place_ship(player, ship, coordinate, direction)
    player.ships.delete(ship)
    redirect "/deploy_wait" if player.ships.empty?
    @current_player = player.name
    @display_name = get_name(player)
    @opponent = get_name(find_opponent(player))
    @board = player.board
    @ships = player.ships
    @next_ship = player.ships.first
    erb :deploy
  end

  get '/deploy_wait' do
    player = session[:player]
    session[:result] = "start"; session[:ship] = "none"
    redirect "/start_shooting" if all_ships_deployed? && my_turn?(player)
    redirect "/shoot_wait" if all_ships_deployed? && !my_turn?(player)
    erb :deploy_wait
  end

  get '/start_shooting' do
    player = player_select(session[:player])
    @attacker = player.name
    @display_name = get_name(player)
    @opponent = find_opponent(player)
    @opponent_name = get_name(@opponent)
    @player_board = player.board
    @shooting_board = player.tracking_board
    erb :start_shooting
  end

  post '/start_shooting' do
    if params[:coordinate] == "" || !valid_coord(receive_coord(params[:coordinate]))
      flash[:error] = "You need to enter a valid coordinate"
      redirect "/start_shooting"
    end
    player = player_select(session[:player])
    coordinate = receive_coord(params[:coordinate])
    opponent = find_opponent(player)
    shot_status = fire!(coordinate, opponent, player)
    if !shot_status
      flash[:error] = "Already targeted that coordinate!" 
      redirect "/start_shooting"
    end
    session[:result] = shot_status
    session[:ship] = shot_status == :Sunk! ? find_ship(coordinate, opponent).name : "none" 
    redirect "/winner" if opponent.ships_left == 0
    game.turns
    redirect "/shoot_wait"
  end

  get '/shoot_wait' do
    player = session[:player]
    @ship = session[:ship]
    @result = session[:result]
    redirect "/start_shooting" if my_turn?(player)
    redirect "/loser" if player_select(player).ships_left == 0
    erb :shoot_wait
  end

  get '/loser' do 
    player = player_select(session[:player])
    @opponent = get_name(find_opponent(player))
    @player = get_name(player)
    erb :loser
  end

  get '/winner' do 
    player = player_select(session[:player])
    @opponent = get_name(find_opponent(player))
    @player = get_name(player)
    erb :winner
  end

  get '/reset' do
    reset_game
    erb :index
  end

  def game
    @@games[session[:id]]
  end

  def reset_game
    @@games[session[:id]].players = []
    session.clear
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end


