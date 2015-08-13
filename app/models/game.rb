class Game < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :boards, dependent: :destroy

  def target_score
    100
  end

  def rounds
    boards.maximum(:round_number) || 0
  end

  def ready_to_start?
    players.all?(&:ready?) && (players.count >= 2)  # TODO use .length since .all? has already loaded all records in SQL
  end
end
