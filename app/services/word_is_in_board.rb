class WordIsInBoard
  attr_reader :board, :word

  def initialize(board:, word:)
    @board = board
    @word = word
  end

  def call
    true
  end

end
