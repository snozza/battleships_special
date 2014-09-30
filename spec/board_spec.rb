require 'board'

describe Board do

	let(:board) {Board.new}
	let(:cell) {double :cell}
	let(:ship) {double :ship}
	let(:patrolboat) {double :patrolboat, size: 2 }
	let(:battleship) {double :battleship, size: 4 }

	context "Upon initialize it" do

		it "should have a grid" do
			expect(board.grid).to_not be nil
		end

		it "should have cells" do
			expect(board.grid.empty?).not_to be true
		end

		it "should have 100 cells" do
			expect(board.grid.flatten.count).to eq(100)
		end	

		it "should give coordinates to cells" do
			expect(board.grid[9][9]).to_not be nil
		end
	end	

	context "During the game it" do

		it "should know how to convert coordinates" do
			expect(board.coord_converter("A1")).to eq [0, 0]
		end

		it "should be able to receive ship starting coordinate" do
			board.place_ship(patrolboat, [0, 0] , "R")
			expect(board.grid[0][0].ship).to eq(patrolboat)
		end

		it "should be able to place patrolboat coordinates" do
			board.place_ship(patrolboat, [0, 0], "R")
			expect(board.grid[0][0].ship).to eq(patrolboat)
			expect(board.grid[0][1].ship).to eq(patrolboat)
		end

		it "should be able to place battleship coordinates" do
			board.place_ship(battleship, [0, 0], "D")
			expect(board.grid[0][0].ship).to eq(battleship)
			expect(board.grid[1][0].ship).to eq(battleship)
			expect(board.grid[2][0].ship).to eq(battleship)
			expect(board.grid[3][0].ship).to eq(battleship)
		end

		it "should be able to verify if ship will not fit on board" do
			expect(board.board_fit?(battleship, [0, 7], "D")).to be false
			expect(board.board_fit?(battleship, [8, 0], "R")).to be false
		 end

		it "should be able to verify is ship will fit on board" do
			expect(board.board_fit?(battleship, [0, 6], "D")).to be true
			expect(board.board_fit?(battleship, [6, 0], "R")).to be true
		end

		it "should be able to check if ship placement will clash" do
			board.place_ship(battleship, [0, 0], "R")
			expect(board.ship_clash?(battleship, [3, 0], "D")).to be false
			expect(board.ship_clash?(battleship, [0, 1], "D")).to be true
		end

		it "should be able to shoot at a coordinate" do
			allow(board.grid[2][3]).to receive(:incoming_shot).and_return(:hit)
			expect(board.shoot_at(2, 3)).to eq(:hit)
		end
	end
end
