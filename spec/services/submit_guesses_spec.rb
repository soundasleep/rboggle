require "rails_helper"

RSpec.describe SubmitGuesses, type: :service do
  let(:user) { User.create! }
  let(:player1) { game.players.create!(user: user) }
  let(:player2) { game.players.create!(user: user) }
  let(:game) { Game.create! }
  let(:board) { game.boards.create!(round_number: 1, serialized_cells: "c,a,t,b|d,o,g,z|z,z,z,z|z,z,z,z") }
  let(:player1_guesses) { board.guesses.where(player: player1) }
  let(:player2_guesses) { board.guesses.where(player: player2) }

  let(:args) {{ board: board, player: player, guesses: guesses }}

  before :each do
    board.save!
    player1.save!
    player2.save!
  end

  context "before called" do
    context "player 1s guesses" do
      it "are empty" do
        expect(player1_guesses).to be_empty
      end
    end

    it "player 1 has not guessed" do
      expect(player1).to_not be_guessed
    end

    it "we have at least one player in the board" do
      expect(board.game.players).to_not be_empty
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

      it "player 2 has not guessed" do
        expect(player2).to_not be_guessed
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

      it "player 2 has not guessed" do
        expect(player2).to_not be_guessed
      end

      context "player 2s guesses" do
        it "are empty" do
          expect(player2_guesses).to be_empty
        end
      end

      context "after player 2 submits guesses too" do
        before { SubmitGuesses.new(board: board, player: player2, guesses: "cat\ndog").call }

        it "player 1 has guessed" do
          expect(player1).to be_guessed
        end

        it "player 2 has guessed" do
          expect(player2).to be_guessed
        end

        context "player 1s guesses" do
          let(:player_guesses) { player1_guesses }

          it "has two" do
            expect(player_guesses.length).to eq(2)
          end

          it "has cat" do
            expect(player_guesses.map(&:word)).to include("cat")
          end

          it "has dog" do
            expect(player_guesses.map(&:word)).to include("dog")
          end
        end

        context "player 2s guesses" do
          let(:player_guesses) { player2_guesses }

          it "has two" do
            expect(player_guesses.length).to eq(2)
          end

          it "has cat" do
            expect(player_guesses.map(&:word)).to include("cat")
          end

          it "has dog" do
            expect(player_guesses.map(&:word)).to include("dog")
          end
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

      # issue #8
      # prevent guess submission after a round has been scored
      context "after 4 seconds" do
        let(:diff) { 4.seconds }

        before { Timecop.freeze(Time.now + diff) }
        after { Timecop.return }

        context "after called with more guesses" do
          before { SubmitGuesses.new(board: board, player: player1, guesses: "frog").call }

          context "player 1s guesses" do
            it "has one" do
              expect(player1_guesses.length).to eq(1)
            end

            it "has frog" do
              expect(player1_guesses.map(&:word)).to include("frog")
            end

            it "does not have cat" do
              expect(player1_guesses.map(&:word)).to_not include("cat")
            end
          end

          context "the board" do
            it "is not finished" do
              expect(board).to_not be_finished
            end
          end
        end
      end

      context "with a finished round" do
        before { board.update! finished: true }

        context "after 2 minutes" do
          let(:diff) { 2.minutes }

          before { Timecop.freeze(Time.now + diff) }
          after { Timecop.return }

          context "after called with more guesses" do
            before { SubmitGuesses.new(board: board, player: player1, guesses: "frog").call }

            context "player 1s guesses" do
              it "has two" do
                expect(player1_guesses.length).to eq(2)
              end

              it "does not have frog" do
                expect(player1_guesses.map(&:word)).to_not include("frog")
              end

              it "has cat" do
                expect(player1_guesses.map(&:word)).to include("cat")
              end
            end

            context "the board" do
              it "is finished" do
                expect(board).to be_finished
              end
            end
          end
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

  context "with a guess in uppercase" do
    let(:guesses) { "CAT" }
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

        it "does not have CAT" do
          expect(player1_guesses.map(&:word)).to_not include("CAT")
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
