class SubmitGuesses
  attr_reader :player, :board, :guesses

  def initialize(player:, board:, guesses:)
    @player = player
    @board = board
    @guesses = guesses
  end

  def call
    board.with_lock do
      board.guesses.where(player: player).destroy_all

      guesses.split.uniq.each do |guess|
        board.guesses.create!(word: guess, player: player)
      end

      player.update!(guessed: true)
      # TODO can do player.guessed! or is this column misnamed?
    end

    # possibly end the round
    EndRound.new(board: board).call

    # TODO if you don't end the round, do you want to possibly finish the game?

    # possibly end the game
    FinishGame.new(game: board.game).call
  end

end
