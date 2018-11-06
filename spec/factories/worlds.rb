FactoryBot.define do
  factory :world do
    sequence(:title)  { |n| "World #{n}" }
    description       { "Description of world '#{title}'" }

    factory :world_with_image do
      image           { fixture_file_upload(fixture_file_name('earth.jpg')) }
      user            { create(:user) }
    end
  end
end
