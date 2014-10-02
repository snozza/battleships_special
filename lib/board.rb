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


	def coord_converter(coordinate)	
    coord = [coordinate.split('', 2)[1].to_i - 1, coordinate.split('', 2)[0].ord - 65]
    return coord if (coord.class == Array && coord[0].is_a?(Integer) && coord[1].is_a?(Integer))
    raise "Coordinate's not valid"
  end

  def board_fit?(ship, coordinate, direction)
    y, x  = coordinate
    return false if direction == "D" && (ship.size + y) > DIMENSION
    return false if direction == "R" && (ship.size + x) > DIMENSION
    true
  end

  def ship_clash? (ship, coordinate, direction)
    y, x = coordinate
    ship.size.times do
      return true if grid[y][x].ship
      direction == "D" ? y += 1 : x += 1
    end
    false
  end
end