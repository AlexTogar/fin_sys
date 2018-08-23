class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|
      t.text :text
      t.bigint :user
      t.bigint :destination
      t.bigint :transaction
      t.boolean :deleted

      t.timestamps
    end
  end
end
