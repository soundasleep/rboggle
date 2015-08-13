require "rails_helper"

RSpec.describe FindOrCreateGame, type: :service do
  let(:user) { User.create! }
  let(:args) { { user: user } }
  let(:service) { FindOrCreateGame.new(args) }

  context "when called" do
    let(:result) { service.call }

    it "returns a Game" do
      expect(result).to be_kind_of(Game)
    end

    let(:game) { result }

    context "the created game" do
      before { game.save! }

      it "has one player" do
        expect(game.players.length).to eq(1)
      end

      it "has the current user as a player" do
        expect(game.players.map(&:user)).to include(user)
      end

      it "has no rounds" do
        expect(game.rounds).to eq(0)
      end

      it "is not started" do
        expect(game).to_not be_started
      end

      it "is not finished" do
        expect(game).to_not be_finished
      end

      it "the current player is not ready" do
        expect(game.players.first).to_not be_ready
      end

      it "is not ready to start" do
        expect(game).to_not be_ready_to_start
      end

      context "when called again" do
        let(:result2) { service.call }

        it "returns a Game" do
          expect(result).to be_kind_of(Game)
        end

        let(:game2) { result2 }

        before { game2.save! }

        context "the created game" do
          it "has one player" do
            expect(game2.players.length).to eq(1)
          end

          it "has the current user as a player" do
            expect(game2.players.map(&:user)).to include(user)
          end
        end
      end
    end

  end

  context "with an existing game" do
    before do
      @game = Game.create!
      another_user = User.create!
      @player = game.players.create!(user: another_user)
    end

    context "when called" do
      let(:result) { service.call }

      it "returns a Game" do
        expect(result).to be_kind_of(Game)
      end

      let(:game) { result }

      context "the created game" do
        it "has two players" do
          expect(game.players.length).to eq(2)
        end

        it "has the current user as a player" do
          expect(game.players.map(&:user)).to include(user)
        end

        it "has no rounds" do
          expect(game.rounds).to eq(0)
        end

        it "is not started" do
          expect(game).to_not be_started
        end

        it "is not finished" do
          expect(game).to_not be_finished
        end

        it "the first player is not ready" do
          expect(game.players.first).to_not be_ready
        end

        it "is not ready to start" do
          expect(game).to_not be_ready_to_start
        end
      end
    end
  end

end
