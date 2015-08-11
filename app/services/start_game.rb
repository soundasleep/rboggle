class StartGame
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

    # TODO check all .map .each uses a space before blocks
    @game.players.each { |player| player.update! ready: false, guessed: false }

    true
  end

  private

  def create_board
    @game.boards.create! round_number: game.rounds + 1, serialized: create_serialized
  end

  def create_serialized
    random_cubes = cubes.shuffle.map do |cube|
      cube.shuffle.first
      # TODO look into array.sample
    end

    rows = []
    # TODO can use .map instead of .each
    # why is this not using board.width/board.height
    # 4.times.
    (0..3).each do |row|
      rows << random_cubes.slice!(0, 4)
    end

    # TODO move into model?
    # look into model serializing?
    # def cells=() <-- i like this one too
    rows.map { |row| row.join(",") }.join("|")
  end

  private

  def cubes
    # from http://www.boardgamegeek.com/thread/300565/review-boggle-veteran-and-beware-different-version
    # "Old version"
    # TODO move this into a constant on the service
    ["aaciot", "ahmors", "egkluy", "abilty",
        "acdemp", "egintv", "gilruw", "elpstu",
        "denosw", "acelrs", "abjmoq", "eefhiy",
        "ehinps", "dknotu", "adevnz", "biforx"].map do |cube|
      cube.chars.map { |c| c == "q" ? "qu" : c }
    end
  end

end
