class EndRound
  attr_reader :board

  def initialize(board:)
    @board = board
  end

  def call
    board.with_lock do
      # TODO add time_has_run_out/board_timer_has_expired private method
      # TODO add all_players_have_guessed
      if board.game.players.all?(&:guessed?) || Time.now > board.expires_at + leeway_time
        # TODO remove board.finished, replace with finished_at != nil
        board.update!(finished: true, finished_at: Time.now)

        # do scoring
        ScoreRound.new(board: board).call

        # round successfully ended
        return true
      end
    end

    false
  end

  private

  def leeway_time
    10.seconds
  end

end
