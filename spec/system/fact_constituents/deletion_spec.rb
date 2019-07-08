RSpec.describe 'Removing a constituent from a fact', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_facts, user: user) }
  let(:fact)  { world.facts.first }
  let(:const) { fact.fact_constituents.first }

  it 'removes linkage to fact', :js, :comprehensive do
    visit world_fact_path(world, fact)
    page.accept_confirm do
      click_link(href: world_fact_fact_constituent_path(world, fact, const),
                 title: 'destroy')
    end
    expect(page).to have_current_path(world_fact_path(world, fact))
    expect(page).to be_i18n_ready
    expect(page).to have_i18n_ready_dialogs(
      'li[id^="fact_constituent"] a[title="destroy"]'
    )
    expect(page).not_to have_content(const.constituable.name)
  end
end
