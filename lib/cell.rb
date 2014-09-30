class Cell

  attr_accessor :ship, :status

  MARKER = {:hit => 'X', :miss => 'O', :empty => '-'}

  def initialize(ship=nil, status=:empty)
    @ship = ship
    @status = status
  end

  def hit
    @status = :hit
    ship.receive_shot
  end

  def miss
    @status = :miss
  end

  def incoming_shot
    raise "Cell already shot" if status != :empty 
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
