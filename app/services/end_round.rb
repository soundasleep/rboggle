class EndRound
  attr_reader :board

  def initialize(board:)
    @board = board
  end

  def call
    if board.game.players.all?(&:guessed?) || Time.now > board.created_at + board.round_length + leeway_time
      board.update! finished: true, finished_at: Time.now

      # do scoring
      ScoreRound.new(board: board).call
    end

    true
  end

  private

  def leeway_time
    5.seconds
  end

end
