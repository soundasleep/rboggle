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

  def all_cells
    @all_cells ||= board.cells.flatten
  end

  def valid_characters
    @valid_characters ||= all_cells.join("").chars.uniq
  end

  def valid_search_space
    load_dictionary.select do |d|
      d.word.length > 2 && d.word.length <= maximum_word_length
    end.select do |d|
      d.word.chars.all? { |c| valid_characters.include?(c) }
    end.select do |d|
      word = d.word
      all_cells.each do |cell|
        word = word.sub(cell, "")
      end
      word.empty?
    end
  end

  def load_dictionary
    # we load the dictionary into memory only once
    @words = Dictionary.all
  end

  def maximum_word_length
    # this is dependent on the cells used to create the game, particularly for 'qu'
    16 + 1
  end

end
