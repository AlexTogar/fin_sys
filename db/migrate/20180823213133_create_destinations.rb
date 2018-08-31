# frozen_string_literal: true

class CreateDestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :destinations do |t|
      t.string :name
      t.integer :sum
      t.date :end_date
      t.integer :portion_sum
      t.text :description
      t.boolean :deleted

      t.timestamps
    end
  end
end
