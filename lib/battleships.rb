require 'sinatra/base'
require 'rack-flash'
require_relative 'game'

class BattleShips < Sinatra::Base

  GAME = Game.new

  enable :sessions
  use Rack::Flash, :sweep => true
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
    if params[:player] == ""
      flash[:error] = "Need to enter a name"
      redirect '/begin'
    end
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
    player = player_select(player)
    @current_player = player.name
    @board = player.board
    @next_ship = player.ships.first
    erb :deploy
  end

  post '/deploy/:player' do |player|
    if params[:coordinate] == "" || params[:direction] == ""
      flash[:error] = "You need to enter a coordinate and a direction"
      redirect "/deploy/#{player}"
    end
    coordinate = receive_coord(params[:coordinate])
    direction = params[:direction]
    player = player_select(player)
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
    player = player_select(player)
    @attacker = player.name
    @opponent = find_opponent(player)
    @player_board = player.board
    @shooting_board = player.tracking_board
    erb :start_shooting
  end

  post '/start_shooting/:player' do |player|
    if params[:coordinate] == ""
      flash[:error] = "You need to enter a coordinate"
      redirect "/start_shooting/#{player}"
    end
    player = player_select(player)
    coordinate = receive_coord(params[:coordinate])
    opponent = find_opponent(player)
    shot_status = fire!(coordinate, opponent, player)
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
    redirect "/loser/#{player}" if player_select(player).ships_left == 0
    erb :shoot_wait
  end

  get '/loser/:player' do |player|
    @player = player
    @opponent = find_opponent(player).name
    erb :loser
  end

  get '/winner/:player' do |player|
    @player = player
    @opponent = find_opponent(player).name
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

  def player_select(player)
    (GAME.players.select {|person| person.name == player})[0]
  end

  def find_opponent(player)
    GAME.my_opponent(player)
  end

  def fire!(coordinate, opponent, player)
    GAME.shoot(coordinate, opponent, player)
  end

  def receive_coord(coordinate)
    GAME.coord_converter(params[:coordinate])
  end



  # start the server if ruby file executed directly
  run! if app_file == $0
end


