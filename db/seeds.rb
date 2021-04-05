# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

first_user = User.create!(email: 'we@we.com', password: 'secrete')
second_user = User.create!(email: 'second@user.com', password: 'secrete')

(1..3).each do |i|
  question = Question.new(title: "Question ##{i}", body: "Text of question ##{i}",
                          author_id: first_user.id)
  question.save
  Answer.new(body: "First answer for question##{i}", question: question,
             author_id: first_user.id).save
  Answer.new(body: "Second answer for question##{i}", question: question,
             author_id: first_user.id).save
  Answer.new(body: "Third answer for question##{i}", question: question,
             author_id: first_user.id).save
end
