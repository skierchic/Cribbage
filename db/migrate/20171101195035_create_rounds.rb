class CreateRounds < ActiveRecord::Migration[5.1]
  def change
    create_table :rounds do |t|
      t.string :current_stage, default: "new", null: false
      t.integer :count, default: 0, null: false
      t.belongs_to :game
      t.integer :active_player_id

      t.timestamps
    end
  end
end
