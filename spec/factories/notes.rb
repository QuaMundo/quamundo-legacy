# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    sequence(:content)  { |n| "Note No. #{n}" }
    association         :noteable
  end
end
