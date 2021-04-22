# frozen_string_literal: true

class CreateBadges < ActiveRecord::Migration[6.1]
  def change
    create_table :badges do |t|
      t.string :title
      t.belongs_to :question, foreign_key: true

      t.timestamps
    end
  end
end
