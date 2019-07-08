RSpec.shared_examples 'associated facts', type: :system do
  # Expect `subject` and `path` to be present
  before(:example) do
    visit path
  end

  it 'shows facts inventory item is part of' do
    subject.facts.each do |fact|
      expect(page).to have_content(fact.name)
      expect(page).to have_content(fact.description)
      expect(page).to have_link(href: world_fact_path(fact.world, fact))
    end
  end
end
