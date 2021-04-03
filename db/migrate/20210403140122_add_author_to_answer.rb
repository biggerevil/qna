# frozen_string_literal: true

class AddAuthorToAnswer < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :author, foreign_key: { to_table: :users }, null: false
  end
end
