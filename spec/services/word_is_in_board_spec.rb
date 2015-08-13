require "rails_helper"

RSpec.describe WordIsInBoard, type: :service do
  let(:game) { Game.create! }
  let(:board) { game.boards.create!(round_number: 1, finished: true, serialized_cells: "c,a,t,b|d,o,g,a|z,z,p,a|qu,z,q,l") }
  let(:result) { WordIsInBoard.new(board: board, word: word).call }

  context "cat" do
    let(:word) { "cat" }

    it "returns true" do
      expect(result).to be(true)
    end
  end

  context "dog" do
    let(:word) { "dog" }

    it "returns true" do
      expect(result).to be(true)
    end
  end

  context "pal" do
    let(:word) { "pal" }

    it "returns true" do
      expect(result).to be(true)
    end
  end

  # diagonal
  context "cot" do
    let(:word) { "cot" }

    it "returns true" do
      expect(result).to be(true)
    end
  end

  context "coat" do
    let(:word) { "coat" }

    it "returns true" do
      expect(result).to be(true)
    end
  end

  # going over the same square
  context "dod" do
    let(:word) { "dod" }

    it "returns false" do
      expect(result).to be(false)
    end
  end

  context "o" do
    let(:word) { "o" }

    it "returns true" do
      expect(result).to be(true)
    end
  end

  # iterating on the same square
  context "dood" do
    let(:word) { "dood" }

    it "returns false" do
      expect(result).to be(false)
    end
  end

  # jumping too far
  context "dtz" do
    let(:word) { "dtz" }

    it "returns false" do
      expect(result).to be(false)
    end
  end

  # wrapping around
  context "zcz" do
    let(:word) { "zcz" }

    it "returns false" do
      expect(result).to be(false)
    end
  end

  # characters that don't exist
  context "cax" do
    let(:word) { "cax" }

    it "returns false" do
      expect(result).to be(false)
    end
  end

  # qu special case
  context "quz" do
    let(:word) { "quz" }

    it "returns true" do
      expect(result).to be(true)
    end
  end

  context "zqu" do
    let(:word) { "zqu" }

    it "returns true" do
      expect(result).to be(true)
    end
  end

  context "qzq" do
    let(:word) { "qzq" }

    it "returns false" do
      expect(result).to be(false)
    end
  end

end
