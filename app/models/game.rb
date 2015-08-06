class Game < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :boards, dependent: :destroy

  def target_score
    10
  end

  def rounds
    if boards.any?
      boards.max_by(&:round_number).round_number
    else
      0
    end
  end

  def ready_to_start?
    players.all?(&:ready?) && (players.count >= 2)
  end
end
