class CreateReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :reasons do |t|
      t.string :reason
      t.integer :often
      t.integer :user
      t.boolean :deleted

      t.timestamps
    end
  end
end
