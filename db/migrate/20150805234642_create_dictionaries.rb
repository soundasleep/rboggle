class CreateDictionaries < ActiveRecord::Migration
  def change
    create_table :dictionaries do |t|
      t.string :word, unique: true, null: false

      t.timestamps null: false
    end

    add_index :dictionaries, :word
  end
end
