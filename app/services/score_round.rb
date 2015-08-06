class ScoreRound
  attr_reader :board

  def initialize(board:)
    @board = board
  end

  def call
    check_all_guesses_are_in_dictionary

    check_all_guesses_are_possible

    check_all_guesses_are_unique

    update_guess_scores

    update_player_scores

    true
  end

  private

  def check_all_guesses_are_in_dictionary
    board.guesses.each do |guess|
      # TODO check for plural/singular
      # alternative: load plural/singular in word loading?
      guess.update! in_dictionary: Dictionary.where(word: guess.word).any?
    end
  end

  def check_all_guesses_are_possible
    board.guesses.each do |guess|
      guess.update! possible: WordIsInBoard.new(board: board, word: guess.word).call
    end
  end

  def check_all_guesses_are_unique
    all_words = board.guesses.map(&:word)

    board.guesses.each do |guess|
      guess.update! unique: all_words.count(guess.word) == 1, checked: true
    end
  end

  def update_guess_scores
    board.guesses.each do |guess|
      if guess.unique? and guess.in_dictionary? and guess.possible?
        guess.update! score: case guess.word.length
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
      else
        guess.update! score: 0
      end
    end
  end

  def update_player_scores
    board.game.players.each do |player|
      round_score = board.guesses.where(player: player).map(&:score).inject(0, &:+)
      player.update! score: player.score + round_score
    end
  end

end
