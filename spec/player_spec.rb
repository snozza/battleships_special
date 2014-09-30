require 'player'

describe Player do 

	let (:player) { Player.new }


	context "on initialize it should" do

		it "have a own board" do
			expect(player.board).not_to be nil
		end

		it "should have 5 ships" do
			expect(player.ships.count).to eq(5)
		end

		it "should be able to have a name" do
			expect(player.name).not_to be nil
		end

		it "should be able to have tracking board" do
			expect(player.tracking_board).to_not be nil
		end

	end
	
end