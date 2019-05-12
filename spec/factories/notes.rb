FactoryBot.define do
  factory :note do
    sequence(:content)  { |n| "Note No. #{n}" }
    association         :noteable
  end
end
