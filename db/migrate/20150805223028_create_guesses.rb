class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.references :player, index: true, foreign_key: true, null: false
      t.references :board, index: true, foreign_key: true, null: false
      t.string :word, null: false
      t.boolean :valid
      t.boolean :checked, null: false, default: false
      t.boolean :unique
      t.integer :score

      t.timestamps null: false
    end
  end
end
