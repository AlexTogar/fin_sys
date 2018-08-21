class CreateReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :reasons do |t|
      t.bigint :user
      t.string :reason
      t.integer :often
      t.boolean :local
      t.boolean :deleted
      t.timestamps
    end
  end
end
