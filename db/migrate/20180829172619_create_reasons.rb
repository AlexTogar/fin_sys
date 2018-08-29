class CreateReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :reasons do |t|
      t.string :reason
      t.boolean :sign
      t.integer :often , default: "0"
      t.boolean :local
      t.bigint :user , default: "#{current_user.id}"
      t.boolean :deleted

      t.timestamps
    end
  end
end
