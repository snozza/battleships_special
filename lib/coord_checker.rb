module CoordChecker

  DIMENSION = 10

  def coord_converter(coordinate=Z20)
    coord = [coordinate.split('', 2)[1].to_i - 1, coordinate.split('', 2)[0].upcase.ord - 65]
    return coord if (coord.class == Array && coord[0].is_a?(Integer) && coord[1].is_a?(Integer))
  end

  def board_fit?(ship, coordinate, direction)
    y, x  = coordinate
    return false if direction == "D" && (ship.size + y) > DIMENSION
    return false if direction == "R" && (ship.size + x) > DIMENSION
    true
  end

  def ship_clash?(ship, coordinate, direction, player)
    y, x = coordinate
    ship.size.times do
      return true if player.board.grid[y][x].ship
      direction == "D" ? y += 1 : x += 1
    end
    false
  end

  def placement_check(ship, coordinate, direction, player) 
    return false if !coordinate
    return false if !direction || !verify_direction(direction)
    y, x = coordinate
    return false if !in_grid(x, y)
    return false if !board_fit?(ship, coordinate, direction)
    return false if ship_clash?(ship, coordinate, direction, player)
    true
  end

  def verify_direction(direction)
    return direction.upcase if direction.upcase == "D" || direction.upcase == "R"
    false
  end

  def in_grid(x, y)
    (0..9).include?(x) && (0..9).include?(y)
  end


end