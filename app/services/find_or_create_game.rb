class FindOrCreateGame
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call
    game = existing_game || create_game

    game.players.create! user: user

    game
  end

  private

  def existing_game
    Game.where(started: false, finished: false).first
  end

  def create_game
    Game.create!
  end
end
