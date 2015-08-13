require "rails_helper"

RSpec.describe FinishGame, type: :service do
  let(:user) { User.create! }
  let(:player1) { game.players.create!(user: user) }
  let(:player2) { game.players.create!(user: user) }
  let(:game) { Game.create! started: true }

  before :each do
    game.save!
    player1.save!
    player2.save!
  end

  context "before called" do
    context "the game" do
      it "is started" do
        expect(game).to be_started
      end

      it "is not finished" do
        expect(game).to_not be_finished
      end
    end
  end

  context "after called" do
    before { FinishGame.new(game: game).call }

    context "the game" do
      it "is started" do
        expect(game).to be_started
      end

      it "is not finished" do
        expect(game).to_not be_finished
      end
    end
  end

  it "the target score is 100" do
    expect(game.target_score).to eq(100)
  end

  context "when player 1 has 20 points" do
    before { player1.update!(score: 20) }

    context "after called" do
      before { FinishGame.new(game: game).call }

      context "the game" do
        it "is started" do
          expect(game).to be_started
        end

        it "is not finished" do
          expect(game).to_not be_finished
        end
      end
    end
  end

  context "when player 1 has 100 points" do
    before { player1.update!(score: 100) }

    context "after called" do
      before { FinishGame.new(game: game).call }

      context "the game" do
        it "is started" do
          expect(game).to be_started
        end

        it "is finished" do
          expect(game).to be_finished
        end
      end
    end
  end

  context "when both players have 200 points" do
    before { player1.update!(score: 200) }
    before { player2.update!(score: 200) }

    context "after called" do
      before { FinishGame.new(game: game).call }

      context "the game" do
        it "is started" do
          expect(game).to be_started
        end

        it "is finished" do
          expect(game).to be_finished
        end
      end
    end
  end

end
