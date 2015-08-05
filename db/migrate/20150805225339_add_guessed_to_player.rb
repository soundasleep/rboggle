class AddGuessedToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :guessed, :boolean, null: false, default: false
    add_index :players, :guessed
  end
end
