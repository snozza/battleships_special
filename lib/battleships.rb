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
    erb :index
  end

  get '/begin' do
    if game_ready?
      flash[:error]= "Game already full"
      redirect '/'
    end
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
    redirect "/deploy/#{session[:player]}" if game_ready?
    redirect '/wait'
  end

  get '/wait' do
    redirect "/deploy/#{session[:player]}" if game_ready?
    erb :wait
  end

  get '/deploy/:player' do |player|
    player = player_select(player)
    @current_player = player.name
    @display_name = get_name(player)
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
    if !placement_check(ship, coordinate, direction, player)
      flash[:error] = "Invalid placement!"; redirect "/deploy/#{player.name}"
    end
    
    place_ship(player, ship, coordinate, direction)
    player.ships.delete(ship)
    redirect "/deploy_wait/#{player.name}" if player.ships.empty?
    @current_player = player.name
    @display_name = get_name(player)
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
    @display_name = get_name(player)
    @opponent = get_name(find_opponent(player))
    @player_board = player.board
    @shooting_board = player.tracking_board
    erb :start_shooting
  end

  post '/start_shooting/:player' do |player|
    if params[:coordinate] == "" || !valid_coord(receive_coord(params[:coordinate]))
      flash[:error] = "You need to enter a valid coordinate"
      redirect "/start_shooting/#{player}"
    end
    player = player_select(player)
    coordinate = receive_coord(params[:coordinate])
    opponent = find_opponent(player)
    shot_status = fire!(coordinate, opponent, player)
    if !shot_status
      flash[:error] = "Already targeted that coordinate!" 
      redirect "/start_shooting/#{player.name}"
    end
    ship = shot_status == :Sunk! ? find_ship(coordinate, opponent).name : "none" 
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
    player = player_select(player)
    @opponent = get_name(find_opponent(player))
    @player = get_name(player)
    erb :loser
  end

  get '/winner/:player' do |player|
    player = player_select(player)
    @opponent = get_name(find_opponent(player))
    @player = get_name(player)
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

  def game_ready?
    GAME.players.count == 2
  end

  def placement_check(ship, coordinate, direction, player)
    GAME.placement_check(ship, coordinate, direction, player)
  end

  def add_player(player)
    GAME.add_player(Player.new(player))
  end

  def find_ship(coordinate, opponent)
    GAME.ship_finder(coordinate, opponent)
  end

  def place_ship(player, ship, coordinate, direction)
    GAME.ask_player_place_ship(player, ship, coordinate, direction)
  end

  def name_converter(player)
    player = player.gsub(/[^A-Za-z\s]/, "").strip
    player = player.gsub(/\s/, "_")
  end

  def valid_coord(coordinate)
    y, x = coordinate
    GAME.in_grid(y, x)
  end

  def get_name(player)
    player = player.name.gsub(/_/, " ")
  end

  def name_used?(name)
    !GAME.players.select {|player| player.name == name}.empty?
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end


