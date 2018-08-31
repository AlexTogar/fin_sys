# frozen_string_literal: true

class CreateReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :reasons do |t|
      t.string :reason
      t.boolean :sign
      t.integer :often
      t.boolean :local
      t.bigint :user
      t.boolean :deleted

      t.timestamps
    end
  end
end
