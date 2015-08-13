require "rails_helper"

RSpec.describe BoardPresenter, type: :service do
  let(:user) { User.create! }
  let(:game) { Game.create! }
  let(:board) { game.boards.create!(round_number: 0, serialized_cells: "empty") }
  let(:presenter) { BoardPresenter.new(board) }

  before :each do
    game.players.create!(user: user)
    game.players.create!(user: user)
  end

  context "#to_json" do
    let(:json) { presenter.to_json }

    it "returns json" do
      expect(json).to_not be_empty
    end
  end

end
