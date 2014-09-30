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
		new(5, "aircraftcarrier", 0)
	end

	def self.battleship
		new(4, "battleship", 0)
	end
	
	def self.submarine
		new(3, "submarine", 0)
	end	

	def self.destroyer
		new(3, "destroyer", 0)
	end

	def self.patrolboat
		new(2, "patrolboat", 0)
	end

end