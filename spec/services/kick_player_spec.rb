require "rails_helper"

RSpec.describe KickPlayer, type: :service do
  let(:user) { User.create! }
  let(:player1) { game.players.create!(user: user, ready: true) }
  let(:player2) { game.players.create!(user: user, ready: true) }
  let(:game) { Game.create! }

  before :each do
    game.save!
    player1.save!
    player2.save!
  end

  context "before called" do
    context "the game" do
      it "has two players" do
        expect(game.players.length).to eq(2)
      end

      it "has player 1" do
        expect(game.players).to include(player1)
      end

      it "has player 2" do
        expect(game.players).to include(player2)
      end

      it "is ready to start" do
        expect(game).to be_ready_to_start
      end
    end
  end

  context "when kicking player 2" do
    before { KickPlayer.new(game: game, player: player2).call }

    context "the game" do
      it "has one players" do
        expect(game.players.length).to eq(1)
      end

      it "has player 1" do
        expect(game.players).to include(player1)
      end

      it "does not have player 2" do
        expect(game.players).to_not include(player2)
      end

      it "is not ready to start" do
        expect(game).to_not be_ready_to_start
      end
    end

    context "when kicking player 2" do
      before { KickPlayer.new(game: game, player: player2).call }

      context "the game" do
        it "has one players" do
          expect(game.players.length).to eq(1)
        end

        it "has player 1" do
          expect(game.players).to include(player1)
        end

        it "does not have player 2" do
          expect(game.players).to_not include(player2)
        end
      end
    end
  end
end
