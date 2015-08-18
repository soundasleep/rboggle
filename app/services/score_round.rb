class ScoreRound
  attr_reader :board

  def initialize(board:)
    @board = board
  end

  def call
    load_dictionary

    board.with_lock do
      check_all_guesses_are_in_dictionary

      check_all_guesses_are_possible

      check_all_guesses_are_unique

      update_guess_scores

      update_player_scores
    end

    true
  end

  private

  def load_dictionary
    # we load the dictionary into memory only once
    @words = Dictionary.pluck(:word)
  end

  def check_all_guesses_are_in_dictionary
    board.guesses.each do |guess|
      guess.update!(in_dictionary: @words.include?(guess.word))
    end
  end

  def check_all_guesses_are_possible
    board.guesses.each do |guess|
      guess.update!(possible: WordIsInBoard.new(board: board, word: guess.word).call)
    end
  end

  def check_all_guesses_are_unique
    all_words = board.guesses.map(&:word)

    board.guesses.each do |guess|
      guess.update!(unique: all_words.count(guess.word) == 1, checked: true)
    end
  end

  def update_guess_scores
    board.guesses.each do |guess|
      if guess.unique? && guess.in_dictionary? && guess.possible?
        guess.update!(score: score_for_word(guess.word))
      else
        guess.update!(score: 0)
      end
    end
  end

  def score_for_word(word)
    case word.length
      when 0, 1, 2
        0
      when 3, 4
        1
      when 5
        2
      when 6
        3
      when 7
        5
      else
        11
    end
  end

  def update_player_scores
    board.game.players.each do |player|
      round_score = board.guesses.where(player: player).map(&:score).inject(0, &:+)
      player.update!(score: player.score + round_score)
    end
  end

end
