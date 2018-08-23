class CreateCapitals < ActiveRecord::Migration[5.2]
  def change
    create_table :capitals do |t|
      t.integer :sum
      t.bigint :user
      t.boolean :local
      t.boolean :deleted

      t.timestamps
    end
  end
end
