class FinishGame
  attr_reader :game

  def initialize(game:)
    @game = game
  end

  def call
    game.with_lock do
      if game.players.any?{ |player| player.score >= game.target_score }
        game.update!(finished: true)
      end
    end

    true
  end

end
