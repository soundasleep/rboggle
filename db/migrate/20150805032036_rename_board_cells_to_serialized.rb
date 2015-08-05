class RenameBoardCellsToSerialized < ActiveRecord::Migration
  def change
    change_table :boards do |t|
      t.rename :cells, :serialized
    end
  end
end
