class ChangeColumnNameAliasToName < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :alias, :name
  end
end
