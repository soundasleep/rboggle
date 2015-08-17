class CreatePossibleWords < ActiveRecord::Migration
  def change
    create_table :possible_words do |t|
      t.references :board, index: true, foreign_key: true, null: false
      t.string :word
      t.references :dictionary, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_index :possible_words, :word
  end
end
