class CreateRound
  # from http://www.boardgamegeek.com/thread/300565/review-boggle-veteran-and-beware-different-version
  # "Old version"
  # TODO maybe move into a GameCube/s service/model? into Game model?
  # which can contain the cube splitting logic too
  CUBE_STRINGS = [
    "aaciot", "ahmors", "egkluy", "abilty",
    "acdemp", "egintv", "gilruw", "elpstu",
    "denosw", "acelrs", "abjmoq", "eefhiy",
    "ehinps", "dknotu", "adevnz", "biforx",
  ]

  attr_reader :game

  def initialize(game:)
    @game = game
  end

  def call
    # TODO fail if game.started?
    create_board    # TODO move into game.with_lock

    game.with_lock do
      # TODO game.started!
      game.update!(started: true)

      game.players.each do |player|
        # TODO player.not_ready! player.not_guessed! or-- player.reset!
        # could also create a new RoundPlayer or ActivePlayer or something to represent
        # one player in each round
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
    # TODO should be build?
    @board = @game.boards.create(round_number: game.rounds + 1)
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
