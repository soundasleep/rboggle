class Game < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :boards, dependent: :destroy

  def rounds
    boards.max(&:round_number) || 0
  end
end
