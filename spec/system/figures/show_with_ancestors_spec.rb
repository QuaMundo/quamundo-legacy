# frozen_string_literal: true

RSpec.describe 'Showing a figure with ancestors',
               type: :system, js: true, comprehensive: true do
  include_context 'Session'

  let(:world)     { build(:world, user: user) }

  figures = %i[figure father mother
               grandfather_m grandmother_m
               grandfather_f grandmother_f
               greatgrandfather greatgrandmother
               son daughter grandson
               other_figure other_father other_son]
  figures.each do |i|
    let(i) { create(:figure, world: world, name: i.to_s) }
  end

  before(:example) do
    figure.ancestors << mother << father
    figure.descendants << son << daughter
    father.ancestors << grandmother_m << grandfather_m
    mother.ancestors << grandmother_f << grandfather_f
    grandfather_m.ancestors << greatgrandmother << greatgrandfather
    son.descendants << grandson
    other_figure.descendants << other_son
    other_figure.ancestors << other_father
  end

  it 'shows ancestors and descendants with degrees' do
    visit world_figure_path(world, figure)
    pedigree = figure.pedigree
    pedigree_figures = [
      father,                 mother,
      grandfather_m,          grandmother_m,
      grandfather_f,          grandmother_f,
      greatgrandfather,       greatgrandmother,
      son,                    daughter,
      grandson
    ]
    expect(pedigree).to contain_exactly(*pedigree_figures)
    page.within('div#pedigree') do
      page.find('div#pedigree-header button').click
      pedigree.each do |fig|
        expect(page).to have_content(fig.name)
        if fig.degree < 0
          expect(page).to have_content("#{fig.degree.abs} degree ancestor")
        else
          expect(page).to have_content("#{fig.degree} degree descendant")
        end
        expect(page).to have_link(href: world_figure_path(world, fig))
      end
    end
  end
end
