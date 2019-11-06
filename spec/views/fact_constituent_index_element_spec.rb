RSpec.describe 'fact_constituents/index', type: :view do
  include_context 'Session'
  let(:constituent)   { create(:fact_constituent,
                              roles: ['role 1', 'role 2']) }
  let(:constituable)  { constituent.constituable }
  let(:fact)          { constituent.fact }
  let(:world)         { fact.world }

  it 'shows a fact constituent index entry' do
    render(partial: 'fact_constituents/index_entry',
           locals: { index_entry: constituent })

    expect(rendered).to have_selector('li.index_entry')
    expect(rendered)
      .to have_selector('.index_entry_name', text: /#{constituable.name}/)
    expect(rendered).to match /#{world.name}/
    expect(rendered).to match /#{fact.name}/
    constituent.roles.each do |role|
      expect(rendered).to match /#{role}/
    end
    
    expect(rendered)
      .to have_link(href: polymorphic_path([world, constituable]))
    expect(rendered)
      .to have_link(
        href: edit_world_fact_fact_constituent_path(world, fact, constituent))
    expect(rendered)
      .to have_link(
        href: world_fact_fact_constituent_path(world, fact, constituent),
        id: /delete-.+/)
  end
end
