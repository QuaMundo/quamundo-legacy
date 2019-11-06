RSpec.describe 'figures/index', type: :view do
  include_context 'Session'
  let(:figure)    { create(:figure) }

  it 'shows a figure index entry' do
    render partial: 'figures/index_entry', locals: { index_entry: figure }

    expect(rendered).to have_selector('li.index_entry')
    expect(rendered)
      .to have_selector('.index_entry_name', text: /#{figure.name}/)
    expect(rendered)
      .to have_selector('.index_entry_description',
                        text: /#{figure.description}/)
    expect(rendered).to match /#{figure.world.name}/
    # FIXME: Better testing for stats!
    expect(rendered).to match /#{figure.facts.count}/
    expect(rendered).to match /#{figure.relatives.count}/

    expect(rendered)
      .to have_link(href: world_figure_path(figure.world, figure))
    expect(rendered)
      .to have_link(href: edit_world_figure_path(figure.world, figure))
    expect(rendered)
      .to have_link(href: world_figure_path(figure.world, figure),
                                  id: /delete-.+/)
  end
end
