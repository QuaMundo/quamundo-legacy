RSpec.describe 'Updating a relation with constituents',
  type: :system, db_triggers: true, js: true, comprehensive: true do
  include_context 'Session'

  let(:world)     { create(:world_with_inventories, user: user) }
  let(:fact)      { create(:fact_with_constituents, world: world) }
  let(:relation)  { create(:relation, fact: fact) }
  let(:fc_1)      { fact.fact_constituents.first }
  let(:fc_2)      { fact.fact_constituents.second }
  let!(:fc_3)     { fact.fact_constituents.third }
  let!(:fc_4)     { fact.fact_constituents.last }
  let!(:rc_1)     { create(:relation_constituent, relation: relation,
                           fact_constituent: fc_1, role: :subject) }
  let!(:rc_2)     { create(:relation_constituent, relation: relation,
                           fact_constituent: fc_2, role: :relative) }

  it 'can add, remove and edit constituents' do
    visit edit_world_fact_relation_path(world, fact, relation)

    # fc_1 should be present with role selected
    sel_1 = "input[value=\"#{fc_1.constituable.name} "\
      "(#{fc_1.constituable_type})\"]"
    opt_1 = "option[value=\"#{rc_1.role}\"][selected=\"selected\"]"
    page.within("div #{sel_1}") do
      page.within(:xpath, '../..') do
        expect(page).to have_selector("div #{opt_1}")
      end
    end

    # also fc_2 should be present with role selected
    # it is going to be removed
    sel_2 = "input[value=\"#{fc_2.constituable.name} "\
      "(#{fc_2.constituable_type})\"]"
    opt_2 = "option[value=\"#{rc_2.role}\"][selected=\"selected\"]"
    expect(page).to have_selector("div #{sel_2}")
    page.within("div #{sel_2}") do
      page.within(:xpath, '../..') do
        expect(page).to have_selector("div #{opt_2}")
        # remove constituent
        page.find("button").click
      end
    end

    # row should be hidden now, _destroy should be set true
    page.within("div #{sel_2}", visible: false) do
      expect(page)
        .to have_selector(:xpath, '../..', class: 'd-none', visible: false)
      page.within(:xpath, '../..', visible: false) do
        expect(page)
          .to have_selector(
            'input[type="hidden"][id$="_destroy"][value="1"]',
            visible: false)
      end
    end

    # add constituents
    page.find(
      'select[id^="relation_relation_constituents_attributes_"]'\
      '[id$="_constituent_id"]'
    ).select(fc_3.constituable.name)
    page.all(
      'select[id^="relation_relation_constituents_attributes_"][id$="_role"]'
    ).last.select('Relative')
    click_button('add-constituent')
    expect(page)
      .to have_selector("input[value^=\"#{fc_3.constituable.name}\"]")


    page.find(
      'select[id^="relation_relation_constituents_attributes_"]'\
      '[id$="_constituent_id"]'
    ).select(fc_4.constituable.name)
    page.all(
      'select[id^="relation_relation_constituents_attributes_"][id$="_role"]'
    ).last.select('Relative')
    page.within("div input[value^=\"#{fc_3.constituable.name}\"]") do
      page.within(:xpath, '../..') do
        page.find('button').click
      end
    end
    expect(page)
      .not_to have_selector("input[value^=\"#{fc_3.constituable.name}\"]")

    click_button('submit')
    relation.reload
    expect(relation.relation_constituents).not_to include(rc_2)
    expect(relation.relation_constituents.map(&:fact_constituent))
      .to contain_exactly(fc_1, fc_4)
    expect(
      relation.relation_constituents.find_by(fact_constituent_id: fc_1.id).role
    ).to eq(rc_1.role)
    # fc_4 was added with role 'relative'
    expect(
      relation.relation_constituents.find_by(fact_constituent_id: fc_4.id).role
    ).to eq('relative')
  end
end
