FactoryBot.define do
  factory :user do
    sequence(:nick)   { |n| "nick_#{n.to_s}" }
    email             { "#{nick}@example.tld" }

    password          { 's3cr3t' }

    factory :user_with_worlds do
      transient do
        worlds_count      { 1 }
      end

      after(:build) do |user, evaluator|
        create_list(:world, evaluator.worlds_count, user: user)
      end
    end

    factory :user_with_worlds_wo_img do
      transient do
        worlds_count      { 1 }
      end

      after(:build) do |user, evaluator|
        create_list(:world, evaluator.worlds_count, user: user, image: nil)
      end
    end
  end
end
