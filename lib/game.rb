require_relative 'player'
require_relative 'board'

class Game
	
	attr_accessor :player1
	attr_accessor :player2

	def initialize(player1="player1", player2="player2")
		@player1 = Player.new(player1)
		@player2 = Player.new(player2)
	end

	def play
		winner = false
		ask_player_place_ship(player1, player1.ships)
		ask_player_place_ship(player2, player2.ships)
		while winner == false
			winner = play_round(player1, player2); break if winner
			winner = play_round(player2, player1)
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
		puts "#{player.name}, where do you want to place your #{ship.name} with size: #{ship.size} (e.g. 'A1')"
		coord = STDIN.gets.chomp.upcase
	 	x, y = player.board.coord_converter(coord)
		return x, y if (0..9).include?(x) && (0..9).include?(y)
			puts "Please enter valid coordinate!" 
			coordinates(player, ship)
		end

	def ask_player_ship_direction(player, ship)
		puts "#{player.name}, what direction do you want to place your #{ship.name} with size: #{ship.size}('R' or 'D')"
		direction = STDIN.gets.chomp.upcase
		return direction if direction == "D" || direction == "R"
		puts "Please enter valid direction"
		ask_player_ship_direction(player, ship)
	end

	def ask_player_shoot(player, opponent)
		puts "#{player.name}, where do you want to shoot? (e.g. 'A1')"
		coord = STDIN.gets.chomp.upcase
		x, y = player.board.coord_converter(coord)
		return x, y if (0..9).include?(x) && (0..9).include?(y) && opponent.board.grid[x][y].status == :empty
		puts "Enter Valid Coords" 
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

