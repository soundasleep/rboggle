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

      guesses.downcase.split.uniq.each do |guess|
        board.guesses.create!(word: guess, player: player)
      end

      player.update!(guessed: true)
      # TODO can do player.guessed! or is this column misnamed?

      # possibly end the round
      ended = EndRound.new(board: board).call

      if ended
        # possibly end the game
        FinishGame.new(game: board.game).call
      end
    end
  end

end
