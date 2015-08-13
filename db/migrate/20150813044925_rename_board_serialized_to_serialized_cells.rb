class RenameBoardSerializedToSerializedCells < ActiveRecord::Migration
  def change
    change_table :boards do |t|
      t.rename :serialized, :serialized_cells
    end
  end
end
