class WordIsInBoard
  attr_reader :board, :word

  def initialize(board:, word:)
    @board = board
    @word = word
  end

  def call
    (0...board.height).each do |start_y|
      (0...board.width).each do |start_x|
        visited = create_empty_visited
        remaining = word

        x = start_x
        y = start_y

        # first characters
        c = board.cell_at(x, y)

        if remaining[0, c.length] == c
          remaining = remaining.slice(c.length, remaining.length)
          visited[y][x] = true

          return true if remaining.empty?
        else
          # this x,y doesn't start the word
          next
        end

        # now search through for connecting characters
        found_next = true
        while !remaining.empty? && found_next
          found_next = false

          (-1..1).each do |dy|
            (-1..1).each do |dx|
              if valid?(x + dx, y + dy)
                if !visited[y + dy][x + dx]
                  c = board.cell_at(x + dx, y + dy)

                  if remaining[0, c.length] == c
                    remaining = remaining.slice(c.length, remaining.length)
                    visited[y + dy][x + dx] = true

                    x += dx
                    y += dy

                    # we've found a match
                    if remaining.empty?
                      return true
                    end

                    found_next = true
                  end
                end
              end
            end
          end
        end
      end
    end

    false
  end

  private

  def create_empty_visited
    board.cells.map do |row|
      row.map { false }
    end
  end

  def valid?(x, y)
    x >= 0 && y >= 0 && x < board.width && y < board.height
  end

end
