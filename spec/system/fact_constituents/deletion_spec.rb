RSpec.describe 'Removing a constituent from a fact', type: :system do
  include_context 'Session'

  let(:const) { create(:fact_constituent, user: user) }
  let(:fact)  { const.fact }
  let(:world) { fact.world }

  it 'removes linkage to fact', :js, :comprehensive do
    visit world_fact_path(world, fact)
    page.find('div#fact_constituents-header button').click
    page.accept_confirm do
      click_link(href: world_fact_fact_constituent_path(world, fact, const),
                 title: 'destroy')
    end
    expect(page).to have_current_path(world_fact_path(world, fact))
    expect(page).not_to have_content(const.constituable.name)
  end
end
