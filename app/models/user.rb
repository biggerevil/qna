# frozen_string_literal: true

class User < ApplicationRecord
  scope :all_except, ->(id) { where.not(id: id) }

  has_many :questions, dependent: :destroy, foreign_key: 'author_id'
  has_many :answers, dependent: :destroy, foreign_key: 'author_id'
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(resource)
    resource.author_id == id
  end
end
