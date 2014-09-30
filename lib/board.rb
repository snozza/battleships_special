require_relative 'cell'

class Board

  attr_reader :grid

  DIMENSION = 10

  def initialize
    @grid = Array.new(DIMENSION).map! {Array.new(DIMENSION).map! {Cell.new}}
  end 

  def place_ship(ship, coordinate, direction)
      x, y = coordinate
      ship.size.times do 
        grid[x][y].ship = ship
        direction == "D" ? x += 1 : y += 1
      end
  end

  def shoot_at(x, y)
    grid[x][y].incoming_shot
  end

  def update_tracking_board(x, y, status)
    grid[x][y].status = status
  end


	def coord_converter(coordinate)	
    coord = [coordinate.split('', 2)[0].upcase.ord - 65, coordinate.split('', 2)[1].to_i - 1]
    return coord if (coord.class == Array && coord[0].is_a?(Integer) && coord[1].is_a?(Integer))
    puts "Invalid coordinate, enter again (format 'A1')"
    coord = STDIN.gets.chomp
    coord_converter(coord)
  end

  def board_fit?(ship, coordinate, direction)
    x, y  = coordinate
    return false if direction == "D" && (ship.size + y) > DIMENSION
    return false if direction == "R" && (ship.size + x) > DIMENSION
    true
  end

  def ship_clash? (ship, coordinate, direction)
    x, y = coordinate
    ship.size.times do
      return true if grid[x][y].ship
      direction == "D" ? x += 1 : y += 1
    end
    false
  end
end