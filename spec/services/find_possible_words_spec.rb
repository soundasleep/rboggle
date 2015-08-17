require "rails_helper"

RSpec.describe FindPossibleWords, type: :service do
  let(:game) { Game.create! }
  let(:board) { game.boards.create!(round_number: 1, finished: true, serialized_cells: "c,a,t,b|d,o,g,a|z,z,p,a|qu,z,q,l") }

  before :each do
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
    context "the board" do
      it "has no possible words" do
        expect(board.possible_words).to be_empty
      end
    end
  end

  context "after called" do
    before { FindPossibleWords.new(board: board).call }

    context "the board" do
      it "has possible words" do
        expect(board.possible_words).to_not be_empty
      end

      context "possible words" do
        let(:words) { board.possible_words.map(&:word) }

        it "includes cat" do
          expect(words).to include("cat")
        end

        it "includes bat" do
          expect(words).to include("bat")
        end

        it "does not include at" do
          expect(words).to_not include("at")
        end

        it "does not include invalid" do
          expect(words).to include("invalid")
        end
      end
    end
  end

end
