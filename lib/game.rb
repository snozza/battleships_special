require_relative 'player'
require_relative 'board'
require_relative 'ship'
require_relative 'cell'

class Game
	
	attr_accessor :players

	def initialize
		@players = []
	end

	def add_player(player)
		players << player
	end

	def play
		winner = false
		ask_player_place_ship(players[0], players[1].ships)
		ask_player_place_ship(players[1], players[1].ships)
		while winner == false
			winner = play_round(players[0], players[1]); break if winner
			winner = play_round(players[1], players[0])
		end
		puts "The winner is #{winner}!!!"
	end

	def ask_player_place_ship(player, ships)
		player.ships.each do |ship|
			player.print_boards(player.board)
			coord = coordinates(player, ship)
			direction = ask_player_ship_direction(player, ship)
			if player.board.board_fit?(ship, coord, direction) && !player.board.ship_clash?(ship, coord, direction)
						player.board.place_ship(ship, coord, direction)
			else
				puts "Ship wont fit. Try again."; redo
			end
		end
	end

	def play_round(player, opponent)
		player.print_boards(player.board)
		player.print_boards(player.tracking_board)
		x, y = ask_player_shoot(player, opponent)
		if !opponent.board.grid[x][y].ship.nil?
			ship_hit(player, opponent, x, y)
		else
			ship_miss(player, opponent, x, y)
		end
		return opponent.ships_left == 0 ? player.name : false  
		end

	def ship_status(ship)
		if ship.sunk?
			puts "You SUNK #{ship.name}!!!"
			true
		else
			puts "You hit #{ship.name}!!!"
			false
		end
	end

	def coordinates(player, ship)
		coord = STDIN.gets.chomp.upcase
		x, y = player.board.coord_converter(coord)
		return x, y if (0..9).include?(x) && (0..9).include?(y)
			puts "Please enter valid coordinate!" 
			coordinates(player, ship)
		end

	def ask_player_ship_direction(player, ship)
		direction = STDIN.gets.chomp.upcase
		return direction if direction == "D" || direction == "R"
		puts "Please enter valid direction"
		ask_player_ship_direction(player, ship)
	end

	def ask_player_shoot(player, opponent)
		coord = STDIN.gets.chomp.upcase
		x, y = player.board.coord_converter(coord)
		return x, y if (0..9).include?(x) && (0..9).include?(y) && opponent.board.grid[x][y].status == :empty
		ask_player_shoot(player, opponent)
	end

	def ship_hit(player, opponent, x, y)
		player.tracking_board.update_tracking_board(x, y, :hit)
		opponent.board.shoot_at(x, y)
		opponent.ships_left -= 1 if ship_status(opponent.board.grid[x][y].ship)
	end

	def ship_miss(player, opponent, x, y)
		player.tracking_board.update_tracking_board(x, y, :miss)
		opponent.board.shoot_at(x, y)
		puts "Miss!!"
		end
	end

