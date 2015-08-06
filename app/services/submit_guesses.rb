class SubmitGuesses
  attr_reader :player, :board, :guesses

  def initialize(player:, board:, guesses:)
    @player = player
    @board = board
    @guesses = guesses
  end

  def call
    @board.guesses.where(player: player).delete_all

    guesses.split(/[\s+]/).reject(&:empty?).uniq.each do |guess|
      @board.guesses.create! word: guess, player: player
    end

    player.update! guessed: true

    # possibly end the round
    EndRound.new(board: board).call

    # possibly end the game
    FinishGame.new(game: board.game).call
  end

  private

end
