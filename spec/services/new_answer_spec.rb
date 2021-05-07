# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAnswerService do
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:subscribed_user) { create(:user) }
  let!(:user_subscription) { create(:subscription, question: question, user: subscribed_user) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notification to subscribed users' do
    expect(NewAnswerMailer).to receive(:new_answer).with(answer, author).and_call_original
    expect(NewAnswerMailer).to receive(:new_answer).with(answer, subscribed_user).and_call_original
    subject.notify(answer)
  end
end
