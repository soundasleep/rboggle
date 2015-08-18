class CreateRound
  # from http://www.boardgamegeek.com/thread/300565/review-boggle-veteran-and-beware-different-version
  # "Old version"
  CUBE_STRINGS = ["aaciot", "ahmors", "egkluy", "abilty",
        "acdemp", "egintv", "gilruw", "elpstu",
        "denosw", "acelrs", "abjmoq", "eefhiy",
        "ehinps", "dknotu", "adevnz", "biforx"]

  attr_reader :game

  def initialize(game:)
    @game = game
  end

  def call
    create_board

    game.with_lock do
      game.update!(started: true)

      game.players.each do |player|
        player.update!(ready: false, guessed: false)
      end
    end

    @board.with_lock do
      FindPossibleWords.new(board: @board).call
    end

    true
  end

  private

  def create_board
    @board = @game.boards.create round_number: game.rounds + 1
    @board.cells = random_cells(@board)
    @board.save!
  end

  def random_cells(board)
    random_cubes = cubes.shuffle.map do |cube|
      cube.sample
    end

    board.height.times.map do |row|
      random_cubes.slice!(0, board.width)
    end
  end

  private

  def cubes
    CUBE_STRINGS.map do |cube|
      cube.chars.map { |c| c == "q" ? "qu" : c }
    end
  end

end
