require_relative 'player'
require_relative 'board'
require_relative 'ship'

class Cell

  attr_accessor :ship, :status, :orientation

  MARKER = {:hit => 'X', :miss => 'O', :empty => '-'}

  def initialize(ship=nil, status=:empty)
    @ship = ship
    @status = status
    @orientation = nil
  end

  def hit
    @status = :hit
    ship.receive_shot
  end

  def miss
    @status = :miss
  end

  def incoming_shot
    miss if !ship
    hit if ship
    return @status
  end

  def to_s
     return '#' if status != :hit && ship
     return MARKER[:hit] if @status == :hit
     return MARKER[:miss] if @status == :miss 
     return MARKER[:empty] if @status == :empty
     
  end
end
