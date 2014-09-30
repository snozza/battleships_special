require 'ship'

describe Ship do

	let (:ship) {Ship.new(2, :ship, 0)}
	let (:aircraftcarrier) {Ship.aircraftcarrier}
	let (:battleship) {Ship.battleship}
	let (:submarine) {Ship.submarine}
	let (:destroyer) {Ship.destroyer} 
	let (:patrolboat) {Ship.patrolboat}


	context "On initialize a ship" do

		it "should have a size" do
			expect(ship.size).not_to eq(0)
		end

		it "should have a name" do
			expect(ship.name).to be(:ship)
		end

		it "has not hit" do
			expect(ship.hit_count).to eq(0)
		end

		it "is not sunk" do
			expect(ship).not_to be_sunk
		end

		it "should raise an error if wrong number of argument" do
			expect{Ship.new(4, :not_a_ship)}.to raise_error(ArgumentError)
		end

		it "should have a name" do
			expect(battleship.name).to eq("battleship")
		end	
	end

	context "During the game a ship" do

		it "can take a hit" do
			expect{ship.receive_shot}.to change{ship.hit_count}.by 1
		end

		it "can't take more hits than its size" do
			2.times{ship.receive_shot}
			expect{ship.receive_shot}.to raise_error(RuntimeError)
		end
	

		it "can be sunk if hits equal its size" do
			2.times{ship.receive_shot}
			expect(ship).to be_sunk
		end
	end

	context "Different types of ships" do	

		it "has a size of 5 if it is an aircraftcarrier" do
			expect(aircraftcarrier.size).to eq(5)
		end

		it "has a size of 4 if it is a battleship" do
			expect(battleship.size).to eq(4)
		end

		it "has a size of 3 if it is a submarine" do
			expect(submarine.size).to eq(3)
		end

		it "has a size of 3 if it is a destroyer" do
			expect(destroyer.size).to eq(3)
		end

		it "has a size of 2 if it is a patrol boat" do
			expect(patrolboat.size).to eq(2)
		end
	end
end