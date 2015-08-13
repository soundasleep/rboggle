require "rails_helper"

RSpec.describe GamePresenter, type: :service do
  let(:user) { User.create! }
  let(:game) { Game.create! }
  let(:presenter) { GamePresenter.new(game) }

  before :each do
    game.players.create!(user: user)
    game.players.create!(user: user)
  end

  context "#to_json" do
    let(:json) { presenter.to_json }

    it "returns json" do
      expect(json).to_not be_empty
    end

    it "returns 2 players" do
      expect(json[:players]).to eq(2)
    end

    it "returns 0 players ready" do
      expect(json[:players_ready]).to eq(0)
    end
  end

  context "#to_data_set" do
    let(:dataset) { presenter.to_data_set }

    it "returns data set" do
      expect(dataset).to_not be_empty
    end

    it "has a data-check-url parameter" do
      expect(dataset["data-check-url"]).to_not be_empty
    end
  end

end
