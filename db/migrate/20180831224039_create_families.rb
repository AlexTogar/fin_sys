class CreateFamilies < ActiveRecord::Migration[5.2]
  def change
    create_table :families do |t|
      t.string :name
      t.string :connect
      t.boolean :deleted
      t.bigint :user

      t.timestamps
    end
  end
end
