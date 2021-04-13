# frozen_string_literal: true

class AddIsBestToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :is_best, :boolean, default: false
  end
end
