class Ship

	attr_reader :size, :name
	attr_accessor :hit_count

	def initialize(size, name, hit_count)
		@size = size
		@name = name
		@hit_count = hit_count
	end

	def receive_shot
		raise "Ships already sunk!" if hit_count == size
		@hit_count += 1
	end

	def sunk?
		@hit_count == size ? true : false
	end

	def self.aircraftcarrier
		new(5, "AircraftCarrier", 0)
	end

	def self.battleship
		new(4, "Battleship", 0)
	end
	
	def self.submarine
		new(3, "Submarine", 0)
	end	

	def self.destroyer
		new(3, "Destroyer", 0)
	end

	def self.patrolboat
		new(2, "Patrolboat", 0)
	end

end