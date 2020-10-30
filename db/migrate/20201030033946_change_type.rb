class ChangeType < ActiveRecord::Migration[6.0]
  def change
    rename_column :gamers, :type, :kind
    rename_column :cells, :type, :kind
  end
end
