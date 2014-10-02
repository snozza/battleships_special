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
    coordinate = GAME.coord_converter(params[:coordinate])
    direction = GAME.verify_direction(params[:direction])
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
    redirect "/start_shooting/#{player}" if all_ships_deployed?
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
    shot_status = GAME.shoot(coordinate, GAME.my_opponent(player), player)
    redirect "/start_shooting/#{player.name}" if !shot_status
    redirect "/shoot_wait/#{player.name}/#{shot_status}"
  end

  get '/shoot_wait/:player/:result' do |player, result|
    @result = result
    erb :shoot_wait
  end

  def all_ships_deployed?
    GAME.players.each do |player|
      return false if !player.ships.empty?
    end
    true
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

