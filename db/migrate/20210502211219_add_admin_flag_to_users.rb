# frozen_string_literal: true

class AddAdminFlagToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean
  end
end
