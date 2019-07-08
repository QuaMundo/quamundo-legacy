FactoryBot.define do
  trait :with_image do
    transient do
      image_file  { fixture_file_name('earth.jpg') }
    end

    image       { fixture_file_upload(image_file) }
  end

  trait :with_notes do
    transient do
      notes_count     { 3 }
    end

    after(:build) do |obj, evaluator|
      create_list(:note, evaluator.notes_count, noteable: obj)
    end
  end

  trait :with_tags do
    transient do
      tagset          { %w{ tag_1 tag_2} }
    end

    after(:build) do |obj, evaluator|
      obj.tag = Tag.new(tagable: obj) unless obj.tag
      obj.tag.tagset = evaluator.tagset
    end
  end

  trait :with_traits do
    transient do
      attributeset    { { a_key: 'a value', another_key: 'another value' } }
    end

    after(:build) do |obj, evaluator|
      obj.trait = Trait.new(traitable: obj) unless obj.trait
      obj.trait.attributeset = evaluator.attributeset
    end
  end

  trait :with_dossiers do
    transient do
      dossiers_count  { 1 }
    end

    after(:build) do |obj, evaluator|
      create_list(:dossier, evaluator.dossiers_count, dossierable: obj)
    end
  end

  trait :with_facts do
    transient do
      facts_count     { 1 }
    end

    after(:build) do |obj, evaluator|
      facts = build_list(:fact, evaluator.facts_count, world: obj.world)
      facts.each do |fact|
        create(:fact_constituent, fact: fact, constituable: obj)
      end
    end
  end
end
