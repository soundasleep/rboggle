# TODO rename to JoinGame?
class FindOrCreateGame
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call
    # TODO add locks
    game = existing_game || create_game

    game.with_lock do
      # only create a new player for unique users
      if !game.players.any?{ |p| p.user == user }
        game.players.create!(user: user)
      end
    end

    game
  end

  private

  def existing_game
    Game.not_started.first
  end

  def create_game
    Game.create!
  end
end
