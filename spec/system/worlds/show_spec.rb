RSpec.describe 'Showing a world', type: :system, login: :user_with_worlds do
  include_context 'Session'

  context 'own worlds' do
    before(:example) { visit world_path(world) }

    it 'shows details of world' do
      expect(page).to have_content(world.title)
      expect(page).to have_content(world.description)
      page.within('div.card-footer nav.context-menu') do
        expect(page).to have_link(href: world_path(world),
                                  class: 'nav-link',
                                  title: 'delete')
        expect(page).to have_link(href: edit_world_path(world),
                                  class: 'nav-link')
        expect(page).to have_link(href: worlds_path, class: 'nav-link')
        expect(page).to have_link(href: new_world_path, class: 'nav-link')
      end
    end

    context 'inventory statistics' do
      specify 'figure statistics' do
        page.within('tr#figures') do
          expect(page)
            .to have_selector('td', text: /Figure/)
          expect(page)
            .to have_selector('td', text: /#{world.figures.count}/)
          expect(page)
            .to have_link(href: world_figures_path(world))
          expect(page)
            .to have_link(href: new_world_figure_path(world))
        end
      end

      specify 'item statistics' do
        page.within('tr#items') do
          expect(page)
            .to have_selector('td', text: /Item/)
          expect(page)
            .to have_selector('td', text: /#{world.items.count}/)
          expect(page)
            .to have_link(href: world_items_path(world))
          expect(page)
            .to have_link(href: new_world_item_path(world))
        end
      end

      specify 'location statistics' do
        page.within('tr#locations') do
          expect(page)
            .to have_selector('td', text: /Location/)
          expect(page)
            .to have_selector('td', text: /#{world.locations.count}/)
          expect(page)
            .to have_link(href: world_locations_path(world))
          expect(page)
            .to have_link(href: new_world_location_path(world))
        end
      end

      specify 'facts statistics'
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_path(world) }
    end

    it_behaves_like 'associated note' do
      let(:subject) { world }
    end

    it_behaves_like 'associated tags' do
      let(:subject) { world }
    end
  end

  context 'other users worlds' do
    before(:example) { visit world_path(other_world) }

    it 'does not show world not owned by logged in user' do
      expect(page).not_to have_current_path(world_path(other_world))
      expect(page).to have_current_path(worlds_path)
      expect(page).to have_selector('aside.alert-danger',
                                   text: 'This is not')
    end
  end
end