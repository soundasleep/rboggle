class JoinGame
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call
    game = existing_game || create_game

    game.with_lock do
      # only create a new player for unique users
      if !game.players.any?{ |p| p.user == user }
        # TODO game.players.where(user: user).first_or_create! [ do |player| ... end ]
        # or - replace this block with a method
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
