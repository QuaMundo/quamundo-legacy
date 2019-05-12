FactoryBot.define do
  factory :world do
    sequence(:title)  { |n| "World #{n}" }
    description       { "Description of world '#{title}'" }
    user              { build(:user) }
    image             { fixture_file_upload(fixture_file_name('earth.jpg')) }

    transient do
      figures_count       { 1 }
      items_count         { 1 }
      locations_count     { 1 }
      notes_count         { 1 }
    end

    after(:create) do |world, evaluator|
      # FIXME: Omit the `each`
      # Problem: with `create_list` the `after(:create)` is not called on the
      # respective object
      create_list(:figure, evaluator.figures_count, world: world)
        .each { |i| i.create_tag(tagset: ["tag_#{rand(5)}"]) }
      create_list(:item, evaluator.items_count, world: world)
        .each { |i| i.create_tag(tagset: ["tag_#{rand(5)}"]) }
      create_list(:location, evaluator.locations_count, world: world)
        .each { |i| i.create_tag(tagset: ["tag_#{rand(5)}"]) }
      create_list(:note, evaluator.notes_count, noteable: world)
      world.create_tag(tagset: (1..rand(3)+2).map { |n| "tag_#{n}" })
    end
  end
end
