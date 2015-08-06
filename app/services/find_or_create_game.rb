class FindOrCreateGame
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call
    game = existing_game || create_game

    # only create a new player for unique users
    if !game.players.any?{ |p| p.user == user }
      game.players.create! user: user
    end

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
