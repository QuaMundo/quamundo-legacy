FactoryBot.define do
  factory :user do
    sequence(:id)     { |n| n }
    nick              { "nick_#{id.to_s}" }
    email             { "#{nick}@example.tld" }

    password          { 's3cr3t' }

    factory :user_with_worlds do
      transient do
        worlds_count      { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:world, evaluator.worlds_count, user: user)
      end
    end

    factory :user_with_worlds_wo_img do
      transient do
        worlds_count      { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:world, evaluator.worlds_count, user: user, image: nil)
      end
    end
  end
end
