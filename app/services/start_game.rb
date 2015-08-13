class StartGame
  # from http://www.boardgamegeek.com/thread/300565/review-boggle-veteran-and-beware-different-version
  # "Old version"
  CUBES = ["aaciot", "ahmors", "egkluy", "abilty",
        "acdemp", "egintv", "gilruw", "elpstu",
        "denosw", "acelrs", "abjmoq", "eefhiy",
        "ehinps", "dknotu", "adevnz", "biforx"]

  attr_reader :game

  def initialize(game:)
    @game = game
  end

  def call
    create_board

    # TODO fail if game has already started
    # TODO locking etc

    # TODO replace update! and create! with update!() and create!()
    @game.update!(started: true)

    @game.players.each { |player| player.update! ready: false, guessed: false }

    true
  end

  private

  def create_board
    board = @game.boards.create round_number: game.rounds + 1
    board.update serialized: create_serialized(board)
    board.save!
  end

  def create_serialized(board)
    random_cubes = cubes.shuffle.map do |cube|
      cube.sample
    end

    rows = board.height.times.map do |row|
      random_cubes.slice!(0, board.width)
    end

    # TODO move into model?
    # look into model serializing?
    # def cells=() <-- i like this one too
    rows.map { |row| row.join(",") }.join("|")
  end

  private

  def cubes
    CUBES.map do |cube|
      cube.chars.map { |c| c == "q" ? "qu" : c }
    end
  end

end
