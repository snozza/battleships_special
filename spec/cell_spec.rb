require 'cell'

describe Cell do

	let(:cell) {Cell.new}
	let(:patrolboat) {double :patrolboat, receive_shot: "shot!"}

	context "upon initialize it" do

		it "should have empty status" do
			expect(cell.status).to be :empty
		end

		it "should have no ship" do

			expect(cell.ship).to eq(nil)
		end
	end
	context "during the game" do

		it "should change status when hit" do
			cell.ship = patrolboat
			expect{cell.hit}.to change{cell.status}.to :hit
		end

		it "should change status when missed" do
			expect{cell.miss}.to change{cell.status}.to :miss
		end

		it "to_s should return 'X' when hit" do
			cell.ship = patrolboat
			cell.hit
			expect(cell.to_s).to eq('X')
		end
	end

		context "if shot at and" do

		it "empty" do
			cell.incoming_shot
			expect(cell.status).to eq(:miss)
		end

		it "has ship" do
			cell.ship = patrolboat
			cell.incoming_shot
			expect(cell.status).to eq(:hit)
		end

		it "is already shot" do
			cell.status = :miss
			expect(lambda {cell.incoming_shot}).to raise_error(RuntimeError)
		end
	end

		context "if occupied by ship" do

			it "it should know which ship it is" do
				cell.ship = :patrolboat
				expect(cell.ship).to eq(:patrolboat)
			end

			it "when hit should report back to ship" do
				patrolboat = double :patrolboat
				cell.ship = patrolboat
				allow(patrolboat).to receive(:receive_shot).and_return(:hit)
				expect(cell.incoming_shot).to eq(:hit)
			end

		end


end
