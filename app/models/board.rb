class Board < ActiveRecord::Base
  has_many :guesses, dependent: :destroy

  def width
    4
  end

  def height
    4
  end

  def cells
    serialized.split("|").map{ |row| row.split(",") }
  end

  def cell_at(x,y)
    cells[y][x]
  end
end
