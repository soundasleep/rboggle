class AddGameToPlayer < ActiveRecord::Migration
  def change
    add_reference :players, :game, index: true, foreign_key: true, null: false
  end
end
