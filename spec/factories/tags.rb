FactoryBot.define do
  factory :tag do
    tagset      { (1..rand(3)+2).map { |n| "tag_#{n}" } }
    association :tagable
  end
end
