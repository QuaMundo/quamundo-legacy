RSpec.describe 'facts/index', type: :view do
  include_context 'Session'
  let(:fact)    { create(:fact,
                         start_date: DateTime.new(2000, 1, 1, 0, 0),
                         end_date: DateTime.new(2000, 12, 31, 23, 59)) }

  it 'shows an fact index entry' do
    render partial: 'facts/index_entry', locals: { index_entry: fact }

    expect(rendered).to have_selector('li.index_entry')
    expect(rendered)
      .to have_selector('.index_entry_name', text: /#{fact.name}/)
    expect(rendered)
      .to have_selector('.index_entry_description', text: /#{fact.description}/)
    expect(rendered).to match /#{fact.world.name}/
    # FIXME: Better testing for stats!
    expect(rendered).to match /Sat, 01 Jan 2000/
    expect(rendered).to match /Sun, 31 Dec 2000/

    expect(rendered).to have_link(href: world_fact_path(fact.world, fact))
    expect(rendered).to have_link(href: edit_world_fact_path(fact.world, fact))
    expect(rendered).to have_link(href: world_fact_path(fact.world, fact),
                                  id: /delete-.+/)
  end
end

