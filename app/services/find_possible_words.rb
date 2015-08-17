class FindPossibleWords
  attr_reader :board

  def initialize(board:)
    @board = board
  end

  def call
    possible_dictionaries.each do |dictionary|
      board.possible_words.create! word: dictionary.word, dictionary: dictionary
    end

    # TODO
    true
  end

  private

  def possible_dictionaries
    valid_search_space.select do |dictionary|
      WordIsInBoard.new(board: board, word: dictionary.word).call
    end
  end

  def valid_search_space
    load_dictionary.select do |d|
      d.word.length > 2 && d.word.length <= 17
    end.select do |d|
      word = d.word
      board.cells.flatten.each do |cell|
        word = word.sub(cell, "")
      end
      word.empty?
    end
  end

  def load_dictionary
    # we load the dictionary into memory only once
    @words = Dictionary.all
  end

end
