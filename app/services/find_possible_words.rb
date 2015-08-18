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
    load_dictionary.select { |d| valid_word_length(d) }
        .select { |d| has_valid_characters(d) }
        .select { |d| has_enough_characters(d) }
  end

  def valid_word_length(dictionary)
    dictionary.word.length >= minimum_word_length && dictionary.word.length <= maximum_word_length
  end

  def has_valid_characters(dictionary)
    dictionary.word.chars.all? { |c| valid_characters.include?(c) }
  end

  def has_enough_characters(dictioanry)
    word = dictioanry.word
    all_cells.each do |cell|
      word = word.sub(cell, "")
    end
    word.empty?
  end

  def all_cells
    @all_cells ||= board.cells.flatten
  end

  def valid_characters
    @valid_characters ||= all_cells.join("").chars.uniq
  end

  def minimum_word_length
    # this is dependent on the scoring algorithm
    3
  end

  def maximum_word_length
    # this is dependent on the cells used to create the game, particularly for 'qu'
    16 + 1
  end

  def load_dictionary
    @dictionary ||= Dictionary.all
  end

end
