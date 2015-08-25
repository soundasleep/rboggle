class SubmitGuesses
  attr_reader :player, :board, :guesses

  def initialize(player:, board:, guesses:)
    @player = player
    @board = board
    @guesses = guesses
  end

  def call
    board.with_lock do
      if board.finished?
        return false
      end

      board.guesses.where(player: player).destroy_all

      guesses.downcase.split.uniq.each do |word|
        board.guesses.create!(word: word, player: player)
      end

      player.update!(guessed: true)
      # TODO can do player.guessed! or is this column misnamed? (guessed_this_round)

      # possibly end the round
      round_has_ended = EndRound.new(board: board).call

      if round_has_ended
        # possibly end the game
        FinishGame.new(game: board.game).call
      end
    end
  end

end
