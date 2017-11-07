class AddGoToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :go, :boolean, null: false, default: false
  end
end
