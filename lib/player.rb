require_relative 'board'
require_relative 'cell'
require_relative 'board'
require_relative 'ship'

class Player

	attr_accessor :patrolboat, :battleship, :submarine, :aircraftcarrier, :destroyer
	attr_accessor :ships, :board, :name, :tracking_board, :ships_left, :last_shot

	def initialize(name="Unknown player")
		@board = Board.new
		@tracking_board = Board.new
		@patrolboat = Ship.patrolboat
		@battleship = Ship.battleship
		@submarine = Ship.submarine
		@aircraftcarrier = Ship.aircraftcarrier
		@destroyer = Ship.destroyer
		@ships = [patrolboat, battleship, submarine, aircraftcarrier, destroyer]
		@name = name
		@ships_left = 5
		@last_shot = tracking_board.grid[0][0]
	end
end


