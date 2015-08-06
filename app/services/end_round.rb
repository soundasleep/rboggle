class EndRound
  attr_reader :board

  def initialize(board:)
    @board = board
  end

  def call
    if board.game.players.all?(&:guessed?) || Time.now > board.created_at + board.round_length
      board.update! finished: true

      # do scoring
      ScoreRound.new(board: board).call
    end

    true
  end

  private

end
