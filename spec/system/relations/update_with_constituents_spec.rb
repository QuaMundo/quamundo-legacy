# frozen_string_literal: true

RSpec.describe 'Updating a relation with constituents',
               type: :system, db_triggers: true, js: true, comprehensive: true do
  include_context 'Session'

  let(:world)     { create(:world_with_inventories, user: user) }
  let(:fact)      { create(:fact_with_constituents, world: world) }
  let(:relation)  { create(:relation, fact: fact) }
  let(:fc1)      { fact.fact_constituents.first }
  let(:fc2)      { fact.fact_constituents.second }
  let!(:fc3)     { fact.fact_constituents.third }
  let!(:fc4)     { fact.fact_constituents.last }
  let!(:rc1)     do
    create(:relation_constituent, relation: relation,
                                  fact_constituent: fc1, role: :subject)
  end
  let!(:rc2) do
    create(:relation_constituent, relation: relation,
                                  fact_constituent: fc2, role: :relative)
  end

  it 'can add, remove and edit constituents' do
    visit edit_world_fact_relation_path(world, fact, relation)

    # fc1 should be present with role selected
    sel1 = "input[value=\"#{fc1.constituable.name} "\
      "(#{fc1.constituable_type})\"]"
    opt1 = "option[value=\"#{rc1.role}\"][selected=\"selected\"]"
    page.within("div #{sel1}") do
      page.within(:xpath, '../..') do
        expect(page).to have_selector("div #{opt1}")
      end
    end

    # also fc2 should be present with role selected
    # it is going to be removed
    sel2 = "input[value=\"#{fc2.constituable.name} "\
      "(#{fc2.constituable_type})\"]"
    opt2 = "option[value=\"#{rc2.role}\"][selected=\"selected\"]"
    expect(page).to have_selector("div #{sel2}")
    page.within("div #{sel2}") do
      page.within(:xpath, '../..') do
        expect(page).to have_selector("div #{opt2}")
        # remove constituent
        page.find('button').click
      end
    end

    # row should be hidden now, _destroy should be set true
    page.within("div #{sel2}", visible: false) do
      expect(page)
        .to have_selector(:xpath, '../..', class: 'd-none', visible: false)
      page.within(:xpath, '../..', visible: false) do
        expect(page)
          .to have_selector(
            'input[type="hidden"][id$="_destroy"][value="1"]',
            visible: false
          )
      end
    end

    # add constituents
    page.find(
      'select[id^="relation_relation_constituents_attributes_"]'\
      '[id$="_constituent_id"]'
    ).select(fc3.constituable.name)
    page.all(
      'select[id^="relation_relation_constituents_attributes_"][id$="_role"]'
    ).last.select('Relative')
    click_button('add-constituent')
    expect(page)
      .to have_selector("input[value^=\"#{fc3.constituable.name}\"]")

    page.find(
      'select[id^="relation_relation_constituents_attributes_"]'\
      '[id$="_constituent_id"]'
    ).select(fc4.constituable.name)
    page.all(
      'select[id^="relation_relation_constituents_attributes_"][id$="_role"]'
    ).last.select('Relative')
    page.within("div input[value^=\"#{fc3.constituable.name}\"]") do
      page.within(:xpath, '../..') do
        page.find('button').click
      end
    end
    expect(page)
      .not_to have_selector("input[value^=\"#{fc3.constituable.name}\"]")

    click_button('submit')
    relation.reload
    expect(relation.relation_constituents).not_to include(rc2)
    expect(relation.relation_constituents.map(&:fact_constituent))
      .to contain_exactly(fc1, fc4)
    expect(
      relation.relation_constituents.find_by(fact_constituent_id: fc1.id).role
    ).to eq(rc1.role)
    # fc4 was added with role 'relative'
    expect(
      relation.relation_constituents.find_by(fact_constituent_id: fc4.id).role
    ).to eq('relative')
  end
end
