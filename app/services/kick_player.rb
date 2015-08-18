class KickPlayer
  attr_reader :game, :player

  def initialize(game:, player:)
    @game = game
    @player = player
  end

  def call
    game.players.destroy(player)

    true
  end

end
