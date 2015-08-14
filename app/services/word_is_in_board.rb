class WordIsInBoard
  attr_reader :board, :word

  def initialize(board:, word:)
    @board = board
    @word = word
  end

  def call
    all_possible_search_trees.any? { |tree| tree.has_word?(word) }
  end

  private

  # TODO look at trie library for ruby?
  def all_possible_search_trees
    (0...board.height).map do |start_y|
      (0...board.width).map do |start_x|
        SearchTree.new(board: board, visited: empty_visited, x: start_x, y: start_y)
      end
    end.flatten
  end

  def empty_visited
    board.cells.map do |row|
      row.map { false }
    end
  end

  class SearchTree
    attr_reader :board, :visited, :x, :y

    def initialize(board:, visited:, x:, y:)
      @board = board
      @visited = visited
      @x = x
      @y = y
    end

    def has_word?(word)
      word.start_with?(cell_string) && has_a_search_tree(remaining(word))
    end

    private

    def all_valid_search_trees
      visited_copy = visited.clone
      visited_copy[y][x] = true

      (-1..1).map do |dy|
        (-1..1).map do |dx|
          if valid_coordinates?(x + dx, y + dy) && !visited_copy[y + dy][x + dx]
            SearchTree.new(board: board, visited: visited_copy, x: x + dx, y: y + dy)
          end
        end
      end.flatten.compact
    end

    def valid_coordinates?(x, y)
      x >= 0 && y >= 0 && x < board.width && y < board.height
    end

    def cell_string
      board.cell_at(x, y)
    end

    def remaining(word)
      word.slice(cell_string.length, word.length)
    end

    def has_a_search_tree(remaining)
      remaining.empty? || all_valid_search_trees.any? { |tree| tree.has_word?(remaining) }
    end

  end

end
