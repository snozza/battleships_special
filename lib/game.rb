require_relative 'player'
require_relative 'board'
require_relative 'ship'
require_relative 'cell'
require_relative 'coord_checker'

class Game
	
	attr_accessor :players

	include CoordChecker

	def initialize
		@players = []
	end

	def add_player(player)
		players << player
	end

	def ask_player_place_ship(player, ship, coord, direction)
			player.board.place_ship(ship, coord, direction)
	end

	def play_round(player, opponent)
		player.print_boards(player.board)
		player.print_boards(player.tracking_board)
		y, x = ask_player_shoot(player, opponent)
		if !opponent.board.grid[y][x].ship.nil?
			ship_hit(player, opponent, y, x)
		else
			ship_miss(player, opponent, y, x)
		end
		return opponent.ships_left == 0 ? player.name : false  
		end

	def ship_status(ship)
		ship.sunk? ? true : false
	end

	def coordinates(player, ship, coord)
		y, x = coord_converter(coord)
		return y, x if (0..9).include?(x) && (0..9).include?(y)
		raise error "invalid coordinates"
	end

	

	def ask_player_shoot(player, opponent)
		y, x = coord_converter(coord)
		return y, x if (0..9).include?(x) && (0..9).include?(y) && opponent.board.grid[y][x].status == :empty
		ask_player_shoot(player, opponent)
	end

	def ship_hit(player, opponent, y, x)
		player.tracking_board.update_tracking_board(y, x, :hit)
		opponent.board.shoot_at(y, x)
		opponent.ships_left -= 1 if ship_status(opponent.board.grid[y][x].ship)
	end

	def ship_miss(player, opponent, y, x)
		player.tracking_board.update_tracking_board(y, x, :miss)
		opponent.board.shoot_at(y, x)
		end
	end

