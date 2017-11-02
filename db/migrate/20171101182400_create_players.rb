class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.integer :score, default: 0, null: false
      t.integer :last_score, default: 0, null: false
      t.boolean :is_dealer, default: false, null: false
      t.belongs_to :user, null: false
      t.belongs_to :game, null: false

      t.timestamps
    end
  end
end
