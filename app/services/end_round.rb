class EndRound
  attr_reader :board

  def initialize(board:)
    @board = board
  end

  def call
    if board.game.players.all?(&:guessed?) || Time.now > board.expires_at + leeway_time
      board.update!(finished: true, finished_at: Time.now)

      # do scoring
      ScoreRound.new(board: board).call
    end

    true
  end

  private

  def leeway_time
    10.seconds
  end

end
