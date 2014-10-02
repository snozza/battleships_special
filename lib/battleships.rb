require 'sinatra/base'
require 'rack-flash'
require_relative 'game'

class BattleShips < Sinatra::Base

  GAME = Game.new

  enable :sessions
  use Rack::Flash
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
    flash[:errors] = "Need to enter a name"
    redirect '/begin' if params[:player] == ""
    GAME.add_player(Player.new(params[:player]))
    session[:player] = params[:player]
    redirect "/deploy/#{session[:player]}" if GAME.players.count == 2
    redirect '/wait'
  end

  get '/wait' do
    redirect "/deploy/#{session[:player]}" if GAME.players.count == 2
    erb :wait
  end

  get '/deploy/:player' do |player|
    player = (GAME.players.select {|person| person.name == player})[0]
    @current_player = player.name
    @board = player.board
    @next_ship = player.ships.first
    erb :deploy
  end

  post '/deploy/:player' do |player|
    flash[:error] = "You to enter a valid coordinate"
    redirect "/deploy/#{player}" if params[:coordinate] == ""
    coordinate = GAME.coord_converter(params[:coordinate])
    redirect "/deploy/#{player}" if coordinate.nil?
    direction = params[:direction]
    player = (GAME.players.select {|person| person.name == player})[0]
    ship = player.ships.first
    redirect "/deploy/#{player.name}" if !GAME.placement_check(ship, coordinate, direction, player)
    
    GAME.ask_player_place_ship(player, ship, coordinate, direction)
    player.ships.delete(ship)
    redirect "/deploy_wait/#{player.name}" if player.ships.empty?
    @current_player = player.name
    @board = player.board
    @ships = player.ships
    @next_ship = player.ships.first
    erb :deploy
  end

  get '/deploy_wait/:player' do |player|
    redirect "/start_shooting/#{player}" if all_ships_deployed? && my_turn?(player)
    redirect "/shoot_wait/#{player}/start/none" if all_ships_deployed? && !my_turn?(player)
    erb :deploy_wait
  end

  get '/start_shooting/:player' do |player|
    player = (GAME.players.select {|person| person.name == player})[0]
    @attacker = player.name
    @opponent = GAME.my_opponent(player)
    @player_board = player.board
    @shooting_board = player.tracking_board
    erb :start_shooting
  end

  post '/start_shooting/:player' do |player|
    player = (GAME.players.select {|person| person.name == player})[0]
    coordinate = GAME.coord_converter(params[:coordinate])
    redirect "/start_shooting/#{player.name}" if !coordinate
    opponent = GAME.my_opponent(player)
    shot_status = GAME.shoot(coordinate, opponent, player)
    ship = shot_status == :Sunk! ? GAME.ship_finder(coordinate, opponent).name : "none" 
    redirect "/start_shooting/#{player.name}" if !shot_status
    redirect "/winner/#{player.name}" if opponent.ships_left == 0
    GAME.turns
    redirect "/shoot_wait/#{player.name}/#{shot_status}/#{ship}"
  end

  get '/shoot_wait/:player/:result/:ship' do |player, result, ship|
    @ship = ship
    @result = result
    redirect "/start_shooting/#{player}" if my_turn?(player)
    redirect "/loser/#{player}" if GAME.players[1].ships_left == 0
    erb :shoot_wait
  end

  get '/loser/:player' do |player|
    @player = player
    @opponent = GAME.my_opponent(player)
    erb :loser
  end

  get '/winner/:player' do |player|
    @player = player
    @opponent = GAME.my_opponent(player).name
    erb :winner
  end

  def all_ships_deployed?
    GAME.players.each do |player|
      return false if !player.ships.empty?
    end
    true
  end

  def my_turn?(player)
    GAME.players[0].name == player
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end


