RSpec.describe 'worlds/index', type: :view do
  include_context 'Session'
  let(:world) do
    world = build(:world_with_facts, facts_count: 2)
    world.facts.first.update_attribute(:start_date, DateTime.new(1800, 1, 1))
    world.facts.last.update_attribute(:end_date, DateTime.new(2200, 12, 31))
    world.save!
    world
  end

  it 'shows a world index entry' do
    render partial: 'worlds/index_entry', locals: { index_entry: world }

    expect(rendered).to have_selector('li.index_entry')
    expect(rendered)
      .to have_selector('.index_entry_name', text: /#{world.name}/)
    expect(rendered)
      .to have_selector('.index_entry_description', text: /#{world.description}/)
    # FIXME: Better testing for stats!
    expect(rendered).to match /Wed, 01 Jan 1800 00:00:00/
    expect(rendered).to match /Wed, 31 Dec 2200 00:00:00/
    # FIXME: Testing world stats missing

    expect(rendered).to have_link(href: world_path(world))
    expect(rendered).to have_link(href: edit_world_path(world))
    expect(rendered).to have_link(href: world_path(world), id: /delete-.+/)
  end
end
