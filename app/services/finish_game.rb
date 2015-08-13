class FinishGame
  attr_reader :game

  def initialize(game:)
    @game = game
  end

  def call
    if game.players.any?{ |player| player.score >= game.target_score }
      game.update!(finished: true)
    end

    true
  end

end
