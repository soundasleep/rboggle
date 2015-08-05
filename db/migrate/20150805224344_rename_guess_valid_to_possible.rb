class RenameGuessValidToPossible < ActiveRecord::Migration
  def change
    change_table :guesses do |t|
      t.rename :valid, :possible
    end
  end
end
