require "rails_helper"

RSpec.describe EndRound, type: :service do
  let(:user) { User.create! }
  let(:player1) { game.players.create!(user: user) }
  let(:player2) { game.players.create!(user: user) }
  let(:game) { Game.create! }
  let(:board) { game.boards.create!(round_number: 1, serialized_cells: "empty") }

  let(:args) {{ board: board }}

  # make sure we have created the board *before* we time travel
  before :each do
    board.save!
    player1.save!
    player2.save!
  end

  context "before called" do
    context "the board" do
      it "is not finished" do
        expect(board).to_not be_finished
      end

      it "has a 3 minute round length" do
        expect(board.round_length).to eq(3.minutes)
      end
    end

    context "player 1" do
      it "has not guessed" do
        expect(player1).to_not be_guessed
      end
    end

    context "player 2" do
      it "has not guessed" do
        expect(player2).to_not be_guessed
      end
    end
  end

  context "after called" do
    before { EndRound.new(board: board).call }

    context "the board" do
      it "is not finished" do
        expect(board).to_not be_finished
      end

      it "does not have a finish date" do
        expect(board.finished_at).to be_nil
      end
    end
  end

  context "after 1 second" do
    let(:diff) { 1.seconds }

    before { Timecop.freeze(Time.now + diff) }
    after { Timecop.return }

    it "the board was created before now" do
      expect(board.created_at).to be < Time.now
    end

    context "before called" do
      context "the board" do
        it "is not finished" do
          expect(board).to_not be_finished
        end
      end
    end

    context "after called" do
      before { EndRound.new(board: board).call }

      context "the board" do
        it "is not finished" do
          expect(board).to_not be_finished
        end
      end
    end
  end

  context "after 2 minutes" do
    let(:diff) { 2.minutes }

    before { Timecop.freeze(Time.now + diff) }
    after { Timecop.return }

    context "before called" do
      context "the board" do
        it "is not finished" do
          expect(board).to_not be_finished
        end
      end
    end

    context "after called" do
      before { EndRound.new(board: board).call }

      context "the board" do
        it "is not finished" do
          expect(board).to_not be_finished
        end
      end
    end

    context "after player 1 guesses" do
      before { player1.update!(guessed: true) }

      context "after called" do
        before { EndRound.new(board: board).call }

        context "the board" do
          it "is not finished" do
            expect(board).to_not be_finished
          end
        end
      end

      context "after player 2 guesses" do
        before { player2.update!(guessed: true) }

        context "after called" do
          before { EndRound.new(board: board).call }

          context "the board" do
            it "is finished" do
              expect(board).to be_finished
            end

            it "has a finish date" do
              expect(board.finished_at).to_not be_nil
            end
          end
        end
      end
    end
  end

  context "after 4 minutes" do
    let(:diff) { 4.minutes }

    before { Timecop.freeze(Time.now + diff) }
    after { Timecop.return }

    context "before called" do
      context "the board" do
        it "is not finished" do
          expect(board).to_not be_finished
        end
      end
    end

    context "after called" do
      before { EndRound.new(board: board).call }

      context "the board" do
        it "is finished" do
          expect(board).to be_finished
        end
      end
    end
  end

end
