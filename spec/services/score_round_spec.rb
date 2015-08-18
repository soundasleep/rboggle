require "rails_helper"

RSpec.describe ScoreRound, type: :service do
  let(:user) { User.create! }
  let(:user2) { User.create! }
  def player1
    # rspec `let` magic means that this reference is lost when with_lock is used
    # so we use `def`s instead and making objects in `before`
    game.players.where(user: user).first
  end
  def player2
    game.players.where(user: user2).first
  end
  let(:game) { Game.create! }
  let(:board) { game.boards.create!(round_number: 1, finished: true, serialized_cells: "c,a,t,b|d,o,g,z|s,z,z,z|z,z,z,z") }

  let(:args) {{ board: board }}

  # make sure we have created the board *before* we time travel
  before :each do
    game.players.create!(user: user)
    game.players.create!(user: user2)
    board.save!

    Dictionary.create!(word: "at")
    Dictionary.create!(word: "bat")
    Dictionary.create!(word: "cat")
    Dictionary.create!(word: "coat")
    Dictionary.create!(word: "dog")
    Dictionary.create!(word: "invalid")
    Dictionary.create!(word: "toads")
    Dictionary.create!(word: "toadsz")
  end

  context "before called" do
    context "player 1" do
      it "has 0 score" do
        expect(player1.score).to eq(0)
      end
    end

    context "player 2" do
      it "has 0 score" do
        expect(player2.score).to eq(0)
      end
    end

    context "possible words" do
      it "are empty" do
        expect(board.possible_words).to be_empty
      end
    end
  end

  context "after called" do
    before { ScoreRound.new(board: board).call }

    context "player 1" do
      it "has 0 score" do
        expect(player1.score).to eq(0)
      end
    end

    context "player 2" do
      it "has 0 score" do
        expect(player2.score).to eq(0)
      end
    end
  end

  context "with player 1 submitting cat,dog" do
    before {
      board.guesses.create!(player: player1, word: "cat")
      board.guesses.create!(player: player1, word: "dog")
    }

    context "before called" do
      context "the first guess" do
        let(:guess) { board.guesses.first }

        it "is not checked" do
          expect(guess).to_not be_checked
        end
      end
    end

    context "after called" do
      before { ScoreRound.new(board: board).call }

      context "the 'cat' guess" do
        let(:guess) { board.guesses.where(player: player1, word: "cat").first }

        it "is checked" do
          expect(guess).to be_checked
        end

        it "is in dictionary" do
          expect(guess).to be_in_dictionary
        end

        it "is possible" do
          expect(guess).to be_possible
        end

        it "is unique" do
          expect(guess).to be_unique
        end

        it "has a score of 1" do
          expect(guess.score).to eq(1)
        end
      end

      context "player 1" do
        it "has 1+1 score" do
          expect(player1.score).to eq(1 + 1)
        end
      end

      context "player 2" do
        it "has 0 score" do
          expect(player2.score).to eq(0)
        end
      end

      context "possible words" do
        it "are empty" do
          expect(board.possible_words).to be_empty
        end
      end
    end

    context "with player 2 submitting cat,dog" do
      before {
        board.guesses.create!(player: player2, word: "cat")
      }

      context "before called" do
        context "the first guess" do
          let(:guess) { board.guesses.first }

          it "is not checked" do
            expect(guess).to_not be_checked
          end
        end
      end

      context "after called" do
        before { ScoreRound.new(board: board).call }

        context "the 'cat' guess" do
          let(:guess) { board.guesses.where(player: player1, word: "cat").first }

          it "is checked" do
            expect(guess).to be_checked
          end

          it "is in dictionary" do
            expect(guess).to be_in_dictionary
          end

          it "is possible" do
            expect(guess).to be_possible
          end

          it "is not unique" do
            expect(guess).to_not be_unique
          end

          it "has a score of 0" do
            expect(guess.score).to eq(0)
          end
        end

        context "player 1" do
          it "has 1 score" do
            expect(player1.score).to eq(1)
          end
        end

        context "player 2" do
          it "has 0 score" do
            expect(player2.score).to eq(0)
          end
        end
      end
    end
  end

  context "with player 1 submitting invalid" do
    before {
      board.guesses.create!(player: player1, word: "invalid")
    }

    context "after called" do
      before { ScoreRound.new(board: board).call }

      context "the 'invalid' guess" do
        let(:guess) { board.guesses.where(player: player1, word: "invalid").first }

        it "is checked" do
          expect(guess).to be_checked
        end

        it "is in dictionary" do
          expect(guess).to be_in_dictionary
        end

        it "is not possible" do
          expect(guess).to_not be_possible
        end

        it "is unique" do
          expect(guess).to be_unique
        end

        it "has a score of 0" do
          expect(guess.score).to eq(0)
        end
      end
    end
  end

  context "with player 1 submitting dogz" do
    before {
      board.guesses.create!(player: player1, word: "dogz")
    }

    context "after called" do
      before { ScoreRound.new(board: board).call }

      context "the 'invalid' guess" do
        let(:guess) { board.guesses.where(player: player1, word: "dogz").first }

        it "is checked" do
          expect(guess).to be_checked
        end

        it "is not in dictionary" do
          expect(guess).to_not be_in_dictionary
        end

        it "is possible" do
          expect(guess).to be_possible
        end

        it "is unique" do
          expect(guess).to be_unique
        end

        it "has a score of 0" do
          expect(guess.score).to eq(0)
        end
      end
    end
  end

  context "with player 1 submitting bat" do
    before {
      board.guesses.create!(player: player1, word: "bat")
    }

    context "after called" do
      before { ScoreRound.new(board: board).call }

      context "the 'invalid' guess" do
        let(:guess) { board.guesses.where(player: player1, word: "bat").first }

        it "is checked" do
          expect(guess).to be_checked
        end

        it "is in dictionary" do
          expect(guess).to be_in_dictionary
        end

        it "is not possible" do
          expect(guess).to_not be_possible
        end

        it "is unique" do
          expect(guess).to be_unique
        end

        it "has a score of 0" do
          expect(guess.score).to eq(0)
        end
      end
    end
  end

  context "with player 1 submitting coat" do
    before {
      board.guesses.create!(player: player1, word: "coat")
    }

    context "after called" do
      before { ScoreRound.new(board: board).call }

      context "the 'coat' guess" do
        let(:guess) { board.guesses.where(player: player1, word: "coat").first }

        it "is checked" do
          expect(guess).to be_checked
        end

        it "is in dictionary" do
          expect(guess).to be_in_dictionary
        end

        it "is possible" do
          expect(guess).to be_possible
        end

        it "is unique" do
          expect(guess).to be_unique
        end

        it "has a score of 1" do
          expect(guess.score).to eq(1)
        end
      end
    end
  end

  context "with player 1 submitting toads" do
    before {
      board.guesses.create!(player: player1, word: "toads")
    }

    context "after called" do
      before { ScoreRound.new(board: board).call }

      context "the 'toads' guess" do
        let(:guess) { board.guesses.where(player: player1, word: "toads").first }

        it "is checked" do
          expect(guess).to be_checked
        end

        it "is in dictionary" do
          expect(guess).to be_in_dictionary
        end

        it "is possible" do
          expect(guess).to be_possible
        end

        it "is unique" do
          expect(guess).to be_unique
        end

        it "has a score of 2" do
          expect(guess.score).to eq(2)
        end
      end
    end
  end
  context "with player 1 submitting toadsz" do
    before {
      board.guesses.create!(player: player1, word: "toadsz")
    }

    context "after called" do
      before { ScoreRound.new(board: board).call }

      context "the 'toadsz' guess" do
        let(:guess) { board.guesses.where(player: player1, word: "toadsz").first }

        it "is checked" do
          expect(guess).to be_checked
        end

        it "is in dictionary" do
          expect(guess).to be_in_dictionary
        end

        it "is possible" do
          expect(guess).to be_possible
        end

        it "is unique" do
          expect(guess).to be_unique
        end

        it "has a score of 3" do
          expect(guess.score).to eq(3)
        end
      end
    end
  end

  context "with player 1 submitting at" do
    before {
      board.guesses.create!(player: player1, word: "at")
    }

    context "after called" do
      before { ScoreRound.new(board: board).call }

      context "the 'at' guess" do
        let(:guess) { board.guesses.where(player: player1, word: "at").first }

        it "is checked" do
          expect(guess).to be_checked
        end

        it "is in dictionary" do
          expect(guess).to be_in_dictionary
        end

        it "is possible" do
          expect(guess).to be_possible
        end

        it "is unique" do
          expect(guess).to be_unique
        end

        it "has a score of 0" do
          expect(guess.score).to eq(0)
        end
      end
    end
  end

end
