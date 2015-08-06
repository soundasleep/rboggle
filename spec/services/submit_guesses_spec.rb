require "rails_helper"

RSpec.describe SubmitGuesses, type: :service do
  let(:user) { User.create! }
  let(:player1) { game.players.create! user: user }
  let(:player2) { game.players.create! user: user }
  let(:game) { Game.create! }
  let(:board) { game.boards.create! round_number: 1, serialized: "empty" }
  let(:player1_guesses) { board.guesses.where(player: player1) }
  let(:player2_guesses) { board.guesses.where(player: player2) }

  let(:args) {{ board: board, player: player, guesses: guesses }}

  context "before called" do
    context "player 1s guesses" do
      it "are empty" do
        expect(player1_guesses).to be_empty
      end
    end

    it "player 1 has not guessed" do
      expect(player1).to_not be_guessed
    end
  end

  context "with no guesses" do
    let(:guesses) { "" }
    let(:player) { player1 }

    context "after called" do
      before { SubmitGuesses.new(args).call }

      context "player 1s guesses" do
        it "are empty" do
          expect(player1_guesses).to be_empty
        end
      end

      it "player 1 has guessed" do
        expect(player1).to be_guessed
      end

      context "player 2s guesses" do
        it "are empty" do
          expect(player2_guesses).to be_empty
        end
      end
    end
  end

  context "with two unique guesses" do
    let(:guesses) { "cat\ndog" }
    let(:player) { player1 }

    context "after called" do
      before { SubmitGuesses.new(args).call }

      context "player 1s guesses" do
        it "has two" do
          expect(player1_guesses.length).to eq(2)
        end

        it "has cat" do
          expect(player1_guesses.map(&:word)).to include("cat")
        end

        it "has dog" do
          expect(player1_guesses.map(&:word)).to include("dog")
        end

        context "the first guess" do
          let(:guess) { player1_guesses.first }

          it "has not been checked" do
            expect(guess).to_not be_checked
          end
        end
      end

      it "player 1 has guessed" do
        expect(player1).to be_guessed
      end

      context "player 2s guesses" do
        it "are empty" do
          expect(player2_guesses).to be_empty
        end
      end

      context "with another two unique guesses" do
        let(:guesses) { "cat\nbird" }
        let(:player) { player1 }

        context "after called" do
          before { SubmitGuesses.new(args).call }

          context "player 1s guesses" do
            it "has two" do
              expect(player1_guesses.length).to eq(2)
            end

            it "has cat" do
              expect(player1_guesses.map(&:word)).to include("cat")
            end

            it "has bird" do
              expect(player1_guesses.map(&:word)).to include("bird")
            end

            context "the first guess" do
              let(:guess) { player1_guesses.first }

              it "has not been checked" do
                expect(guess).to_not be_checked
              end
            end
          end

          it "player 1 has guessed" do
            expect(player1).to be_guessed
          end

          context "player 2s guesses" do
            it "are empty" do
              expect(player2_guesses).to be_empty
            end
          end
        end
      end
    end
  end

  context "with two unique guesses separated by spaces" do
    let(:guesses) { " cat dog " }
    let(:player) { player1 }

    context "after called" do
      before { SubmitGuesses.new(args).call }

      context "player 1s guesses" do
        it "has two" do
          expect(player1_guesses.length).to eq(2)
        end

        it "has cat" do
          expect(player1_guesses.map(&:word)).to include("cat")
        end

        it "has dog" do
          expect(player1_guesses.map(&:word)).to include("dog")
        end

        context "the first guess" do
          let(:guess) { player1_guesses.first }

          it "has not been checked" do
            expect(guess).to_not be_checked
          end
        end
      end

      it "player 1 has guessed" do
        expect(player1).to be_guessed
      end

      context "player 2s guesses" do
        it "are empty" do
          expect(player2_guesses).to be_empty
        end
      end
    end
  end
  context "with two unique guesses separated by spaces" do
    let(:guesses) { "cat\ncat dog \n" }
    let(:player) { player1 }

    context "after called" do
      before { SubmitGuesses.new(args).call }

      context "player 1s guesses" do
        it "has two" do
          expect(player1_guesses.length).to eq(2)
        end

        it "has cat" do
          expect(player1_guesses.map(&:word)).to include("cat")
        end

        it "has dog" do
          expect(player1_guesses.map(&:word)).to include("dog")
        end

        context "the first guess" do
          let(:guess) { player1_guesses.first }

          it "has not been checked" do
            expect(guess).to_not be_checked
          end
        end
      end

      it "player 1 has guessed" do
        expect(player1).to be_guessed
      end

      context "player 2s guesses" do
        it "are empty" do
          expect(player2_guesses).to be_empty
        end
      end
    end
  end
  context "with one unique guesses" do
    let(:guesses) { "cat\ncat" }
    let(:player) { player1 }

    context "after called" do
      before { SubmitGuesses.new(args).call }

      context "player 1s guesses" do
        it "has one" do
          expect(player1_guesses.length).to eq(1)
        end

        it "has cat" do
          expect(player1_guesses.map(&:word)).to include("cat")
        end
      end

      it "player 1 has guessed" do
        expect(player1).to be_guessed
      end

      context "player 2s guesses" do
        it "are empty" do
          expect(player2_guesses).to be_empty
        end
      end
    end
  end

  context "with two unique guesses with lots of whitespace" do
    let(:guesses) { "\ncat\n  dog \n dog\n cat\n" }
    let(:player) { player1 }

    context "after called" do
      before { SubmitGuesses.new(args).call }

      context "player 1s guesses" do
        it "has two" do
          expect(player1_guesses.length).to eq(2)
        end

        it "has cat" do
          expect(player1_guesses.map(&:word)).to include("cat")
        end

        it "has dog" do
          expect(player1_guesses.map(&:word)).to include("dog")
        end
      end

      it "player 1 has guessed" do
        expect(player1).to be_guessed
      end

      context "player 2s guesses" do
        it "are empty" do
          expect(player2_guesses).to be_empty
        end
      end
    end
  end

end