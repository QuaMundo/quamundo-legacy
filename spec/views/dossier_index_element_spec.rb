RSpec.describe 'dossiers/index_entry', type: :view do
  include_context 'Session'
  let(:world)     { create(:world) }
  let(:dossier)   { create(:dossier, dossierable: world) }

  it 'shows a dossier index entry' do
    render partial: 'dossiers/index_entry', locals: { index_entry: dossier }

    expect(rendered).to have_selector('li.index_entry')
    expect(rendered)
      .to have_selector('.index_entry_name', text: /#{dossier.name}/)
    expect(rendered)
      .to have_selector('.index_entry_description',
                        text: /#{dossier.description}/)

    # FIXME: Check for stats

    expect(rendered)
      .to have_link(href: polymorphic_path([dossier.try(:world), dossier]))
    expect(rendered)
      .to have_link(href: edit_polymorphic_path([dossier.try(:world), dossier]))
    expect(rendered)
      .to have_link(href: polymorphic_path([dossier.try(:world), dossier]),
                    id: /delete-.+/)
  end
end
