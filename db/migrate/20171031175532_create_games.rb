class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.boolean :in_progress, null: false, default: false
      t.boolean :needs_a_player, null: false, default: true
      t.integer :winner_id

      t.timestamps
    end
  end
end
