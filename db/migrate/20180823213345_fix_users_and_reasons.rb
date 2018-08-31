# frozen_string_literal: true

class FixUsersAndReasons < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :admin, :boolean
    add_column :users, :family, :bigint
  end
end
