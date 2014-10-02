require 'game'
require 'player'
require 'ship'
require 'board'

describe Game do 
	
		let(:game) {Game.new}
		let(:player1) {double :player, name: "player1", board: board, tracking_board: tracking_board, place_ship: true}
		let(:battleship) {double :battleship, name: :battleship, size: 4}
		let(:STDIN) {double :STDIN}
		let(:player2) {double :player, name: "player2", board: board, tracking_board: tracking_board, place_ship: true}
		let(:board) {double :board, grid: []}
		let(:tracking_board) {double :tracking_board, grid: []}
		let(:cell) {Cell.new}
 
	context "Upon initialize" do	

		it "should start with an array for players undefined" do
			expect(game.players.empty?).to be true
		end
	end

	context "at beginning of game" do	

		before(:each) do
			game.add_player(player1)
			game.add_player(player2)
		end

		it "should ask player for direction" do
			allow(STDIN).to receive(:gets).and_return("R")
			expect(game.ask_player_ship_direction(game.players[0], battleship)).to eq("R")
		end

		it "should receive user input for coordinate" do
			allow(STDIN).to receive(:gets).and_return('A1')
			allow(game).to receive(:coordinates).and_return [0,0]
			expect(game.coordinates(player1, battleship)).to eq [0,0]

		end

		it "should receive user input for direction" do
			allow(STDIN).to receive(:gets).and_return("R")
			expect(game.ask_player_ship_direction(game.players[0], battleship)).to eq("R")
		end
	end

	context "during the game" do

		it "should receive user input for shooting coordinate" do
			allow(STDIN).to receive(:gets).and_return('A1')
			allow(game). to receive(:ask_player_shoot).and_return [0,0]
			expect(game.ask_player_shoot(game.players[0], game.players[1])).to eq([0,0])
		end

		it "should hit when shoot coord given and there is ship" do
			allow(board).to receive(:update_tracking_board).and_return true
			allow(game).to receive(:ship_status).and_return true
			allow(board).to receive(:shoot_at).and_return battleship
		end

		it "should report if shot is hit or miss" do
			allow(battleship).to receive(:sunk?).and_return true
			expect(game.ship_status(battleship)).to eq true
		end

	end

	
end

