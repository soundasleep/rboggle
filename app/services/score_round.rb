class ScoreRound
  attr_reader :board

  def initialize(board:)
    @board = board
  end

  def call
    load_dictionary

    board.with_lock do
      # TODO update_that_all_guesses_might_be_in_the_dictionary
      # or update_guesses_from_dictionary
      # TODO board.guesses.each do |guess| ... ? in a separate method
      # --> update_guess_score_flags / do_the_thing
      # that way the guesses can all be updated just once
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
      # TODO could put this into a method on Guess, guess.in_dictionary? -> { ... }
      # check performance?
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
      # TODO move checked out of this method
    end
  end

  def update_guess_scores
    board.guesses.each do |guess|
      # TODO check to see what happens (performance) if all of these are calculated at runtime
      if guess.unique? && guess.in_dictionary? && guess.possible?
        guess.update!(score: score_for_word(guess.word))
      else
        guess.update!(score: 0)
      end
    end
  end

  def score_for_word(word)
    case word.length
      # TODO replace with a single math using fourier transforms
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
      # TODO add player.with_lock
      # TODO replace .inject -> .sum or .map() -> .sum(:score)
      # TODO check that these return 0 not nil
      round_score = board.guesses.where(player: player).map(&:score).inject(0, &:+)
      player.update!(score: player.score + round_score)
    end
  end

end
