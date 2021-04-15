# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    tagset      { (1..rand(2..4)).map { |n| "tag_#{n}" } }
    association :tagable
  end
end
