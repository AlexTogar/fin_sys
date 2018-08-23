class CreatePlanTables < ActiveRecord::Migration[5.2]
  def change
    create_table :plan_tables do |t|
      t.text :data
      t.date :date_begin
      t.date :date_end
      t.boolean :local
      t.boolean :deleted

      t.timestamps
    end
  end
end
