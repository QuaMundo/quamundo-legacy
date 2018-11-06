FactoryBot.define do
  factory :user do
    sequence(:email)  { |n| "test_#{n}@example.tld" }
    sequence(:id)     { |n| n }
    sequence(:nick)   { |n| "nick_#{n}" }

    password          { 's3cr3t' }

    factory :user_with_worlds do
      transient do
        worlds_count      { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:world, evaluator.worlds_count, user: user)
      end
    end
  end
end
