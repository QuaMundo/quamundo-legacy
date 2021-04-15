# frozen_string_literal: true

RSpec.describe 'Creating a relation with constituents',
               type: :system, db_triggers: true, js: true, comprehensive: true do
  include_context 'Session'

  let(:world)       { create(:world, user: user) }
  let(:fact)        { create(:fact_with_constituents, world: world) }
  let(:relation)    { create(:relation, fact: fact) }
  let(:fc1)        { fact.fact_constituents.first }
  let(:fc2)        { fact.fact_constituents.second }

  it 'can add and remove constituents' do
    visit new_world_fact_relation_path(world, fact)
    fill_in('Name', with: 'relates to')
    # Some variables to shorten lines ...
    csel = 'select[id^="relation_relation_constituents_attributes"][id$="_id"]'
    rsel = 'select[id^="relation_relation_constituents_attributes"][id$="_role"]'
    # Add 1st constituent
    page.find(csel).select(fc1.constituable.name)
    page.find(rsel).select('Relative')
    click_button(id: 'add-constituent')
    # Skipping same tests as they are tested in
    # update_with_constituents_spec.rb

    # Add 2nd constituent
    page.all(csel).last.select(fc2.constituable.name)
    page.all(rsel).last.select('Subject')

    # Remove 1st constituents
    page.first('div.relation_constituent_entry').find('button').click

    # Submit and check result
    click_button('submit')

    fact.reload
    expect(fact.relations.count).to eq(1)
    expect(page).to have_content(fc2.constituable.name)
    expect(page).not_to have_content(fc1.constituable.name)
  end
end
