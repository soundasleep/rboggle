class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.integer :score, null: false, default: 0
      t.boolean :ready, null: false, default: false
      t.boolean :finished, null: false, default: false

      t.timestamps null: false
    end

    add_index :players, :ready
    add_index :players, :finished
  end
end
