class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.string :suit, null: false
      t.string :rank, null: false
      t.boolean :played, default: false, null: false
      t.boolean :in_crib, default: false, null: false
      t.integer :player_id
      t.integer :deck_id

      t.timestamps
    end
  end
end
