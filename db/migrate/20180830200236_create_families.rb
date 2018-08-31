# frozen_string_literal: true

class CreateFamilies < ActiveRecord::Migration[5.2]
  def change
    create_table :families do |t|
      t.integer :name
      t.integer :connect
      t.bigint :user
      t.boolean :deleted

      t.timestamps
    end
  end
end
