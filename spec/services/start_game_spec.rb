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
              expect(board.cells).to_not be_empty
            end

            it "has a width of 4" do
              expect(board.width).to eq(4)
            end

            it "has a height of 4" do
              expect(board.height).to eq(4)
            end

            it "has a cell at (0,0)" do
              expect(board.cell_at(0,0)).to_not be_empty
            end

            it "has a cell at (3,3)" do
              expect(board.cell_at(3,3)).to_not be_empty
            end

            it "has a value at (0,0)" do
              expect(board.cell_at(0,0)).to match(/^[a-z]{1,2}$/)
            end

            it "has 4 rows of cells" do
              expect(board.cells.length).to eq(4)
            end

            it "has 4 columns of cells" do
              expect(board.cells[0].length).to eq(4)
            end

            it "returns the same value through cells and cell_at (0,0)" do
              expect(board.cell_at(0,0)).to eq(board.cells[0][0])
            end

            it "returns the same value through cells and cell_at (1,3)" do
              expect(board.cell_at(1,3)).to eq(board.cells[3][1])
            end

            it "is round 1" do
              expect(board.round_number).to eq(1)
            end
          end

          context "with another game" do
            let(:game2) { Game.create! }

            before :each do
              game2.players.create! user: user
              game2.players.create! user: user
              StartGame.new(game: game2).call
            end

            it "is different from the first game" do
              expect(game).to_not eq(game2)
            end

            it "has different boards" do
              expect(game.boards.first).to_not eq(game2.boards.first)
            end

            it "has different cells" do
              expect(game.boards.first.cells).to_not eq(game2.boards.first.cells)
            end
          end
        end
      end
    end
  end

end
