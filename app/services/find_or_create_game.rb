# TODO rename to JoinGame?
class FindOrCreateGame
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call
    # TODO add locks
    game = existing_game || create_game

    # only create a new player for unique users
    if !game.players.any?{ |p| p.user == user }
      game.players.create! user: user
    end

    game
  end

  private

  def existing_game
    # TODO rename to Game scope
    # Game.waiting_for_players? Game.not_started?
    # TODO remove finished: false
    Game.where(started: false, finished: false).first
  end

  def create_game
    Game.create!
  end
end
