module Helpers

  def all_ships_deployed?
    game.players.each do |player|
      return false if !player.ships.empty?
    end
    true
  end

  def my_turn?(player)
    game.players[0].name == player
  end

  def player_select(player)
    (game.players.select {|person| person.name == player})[0]
  end

  def find_opponent(player)
    game.my_opponent(player)
  end

  def fire!(coordinate, opponent, player)
    game.shoot(coordinate, opponent, player)
  end

  def receive_coord(coordinate)
    game.coord_converter(params[:coordinate])
  end

  def game_ready?
    game.players.count == 2
  end

  def placement_check(ship, coordinate, direction, player)
    game.placement_check(ship, coordinate, direction, player)
  end

  def add_player(player)
    game.add_player(Player.new(player))
  end

  def find_ship(coordinate, opponent)
    game.ship_finder(coordinate, opponent)
  end

  def place_ship(player, ship, coordinate, direction)
    game.ask_player_place_ship(player, ship, coordinate, direction)
  end

  def name_converter(player)
    player = player.gsub(/[^A-Za-z\s]/, "").strip
    player = player.gsub(/\s/, "_")
  end

  def valid_coord(coordinate)
    y, x = coordinate
    game.in_grid(y, x)
  end

  def get_name(player)
    player = player.name.gsub(/_/, " ")
  end

  def name_used?(name)
    !game.players.select {|player| player.name == name}.empty?
  end

end