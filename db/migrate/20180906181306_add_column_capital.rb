class AddColumnCapital < ActiveRecord::Migration[5.2]
  def change
    add_column :capitals, :sign, :boolean, default: false
    remove_column :capitals, :local, :boolean
    remove_column :capitals, :deleted, :boolean
    add_column :capitals, :deleted, :boolean, default: false
  end
end
