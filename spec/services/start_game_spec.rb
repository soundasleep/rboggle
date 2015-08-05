require "rails_helper"

RSpec.describe StartGame, type: :service do
  let(:user) { User.create! }
  let(:game) { Game.create! }

  before :each do
    game.players.create! user: user
    game.players.create! user: user
  end

  let(:args) { { game: game } }
  let(:service) { StartGame.new(args) }

  context "before called" do
    context "the game" do
      it "is not ready to start" do
        expect(game).to_not be_ready_to_start
      end

      it "has zero rounds" do
        expect(game.rounds).to eq(0)
      end

      it "has no boards" do
        expect(game.boards).to be_empty
      end
    end

    context "after both players are ready to start" do
      before { game.players.each{ |p| p.update! ready: true } }

      it "the game is ready to start" do
        expect(game).to be_ready_to_start
      end

      context "after called" do
        let(:result) { service.call }

        it "returns true" do
          expect(result).to eq(true)
        end

        context "the started game" do
          before { service.call }

          it "is started" do
            expect(game).to be_started
          end

          it "is not finished" do
            expect(game).to_not be_finished
          end

          it "has one round" do
            expect(game.rounds).to eq(1)
          end

          it "has one board" do
            expect(game.boards.length).to eq(1)
          end

          context "the created board" do
            let(:board) { game.boards.first }

            it "is not finished" do
              expect(board).to_not be_finished
            end

            it "has cells" do
              # TODO this will return an array of Cells (a Concept) each with x,y
              expect(board.cells).to_not be_empty
            end

            it "is round 1" do
              expect(board.round_number).to eq(1)
            end
          end
        end
      end
    end
  end

end
