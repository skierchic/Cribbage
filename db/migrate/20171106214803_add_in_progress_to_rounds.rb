class AddInProgressToRounds < ActiveRecord::Migration[5.1]
  def change
    add_column :rounds, :in_progress, :boolean, null: false, default: true
  end
end
