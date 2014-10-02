require_relative 'player'
require_relative 'cell'
require_relative 'ship'


class Board

  attr_reader :grid

  DIMENSION = 10

  def initialize
    @grid = Array.new(DIMENSION).map! {Array.new(DIMENSION).map! {Cell.new}}
  end 

  def place_ship(ship, coordinate, direction)
      y, x = coordinate
      ship.size.times do 
        grid[y][x].ship = ship
        direction == "D" ? y += 1 : x += 1
      end
  end

  def shoot_at(y, x)
    grid[y][x].incoming_shot
  end

  def update_tracking_board(y, x, status)
    grid[y][x].status = status
  end


	
end