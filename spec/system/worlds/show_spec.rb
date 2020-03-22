RSpec.describe 'Showing a world', type: :system do
  include_context 'Session'

  let(:world) { create(:world, user: user) }
  let(:other_world) { create(:world) }

  context 'own worlds' do
    before(:example) { visit world_path(world) }

    it 'shows details of world' do
      page.find('.nav-item a.nav-link.dropdown').click
      expect(page).to have_content(world.name)
      expect(page).to have_content(world.description)
      page.within('ul.nav') do
        expect(page).to have_link(href: world_path(world),
                                  class: 'dropdown-item',
                                  title: 'delete')
        expect(page).to have_link(href: edit_world_path(world),
                                  class: 'dropdown-item')
        expect(page).to have_link(href: edit_world_permissions_path(world))
        expect(page).to have_link(href: worlds_path, class: 'dropdown-item')
        expect(page).to have_link(href: new_world_path, class: 'dropdown-item')
      end
    end

    context 'inventory statistics' do
      specify 'figure statistics' do
        page.within('#figures') do
          expect(page)
            .to have_text(/Figure/)
          expect(page)
            .to have_text(/#{world.figures.count}/)
          expect(page)
            .to have_link(href: new_world_figure_path(world))
        end
      end

      specify 'item statistics' do
        page.within('#items') do
          expect(page)
            .to have_text(/Item/)
          expect(page)
            .to have_text(/#{world.items.count}/)
          expect(page)
            .to have_link(href: new_world_item_path(world))
        end
      end

      specify 'location statistics' do
        page.within('#locations') do
          expect(page)
            .to have_text(/Location/)
          expect(page)
            .to have_text(/#{world.locations.count}/)
          expect(page)
            .to have_link(href: new_world_location_path(world))
        end
      end

      specify 'concept statistics' do
        page.within('#concepts') do
          expect(page)
            .to have_text(/Concept/)
          expect(page)
            .to have_text(/#{world.concepts.count}/)
          expect(page)
            .to have_link(href: new_world_concept_path(world))
        end
      end

      specify 'facts statistics' do
        page.within('#facts') do
          expect(page)
            .to have_text(/Fact/)
          expect(page)
            .to have_text(/#{world.facts.count}/)
          expect(page)
            .to have_link(href: new_world_fact_path(world))
        end
      end
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_path(world) }
    end

    it_behaves_like 'associated note' do
      let(:subject) { create(:world_with_notes, user: user) }
    end

    it_behaves_like 'associated tags' do
      let(:subject) { create(:world_with_tags, user: user) }
    end

    it_behaves_like 'associated traits' do
      let(:subject) { create(:world_with_traits, user: user) }
    end

    it_behaves_like 'associated dossiers' do
      let(:subject) { create(:world_with_dossiers, user: user) }
    end

    it_behaves_like 'associated facts' do
      let(:subject) { create(:world_with_facts, facts_count: 2, user: user) }
      let(:path)    { world_path(subject) }
    end
  end

  context 'with image' do
    before(:example) do
      world.image = fixture_file_upload(fixture_file_name('earth.jpg'))
      world.save
      visit(world_path(world, world))
    end

    it 'has an img tag' do
      expect(page).to have_selector('img.world-image')
    end
  end

  context 'other users worlds' do
    before(:example) { visit world_path(other_world) }

    it 'does not show world not owned by logged in user' do
      expect(page).not_to have_current_path(world_path(other_world))
      expect(page).to have_current_path(worlds_path)
      expect(page).to have_selector('aside.alert-danger',
                                   text: /^You are not allowed/)
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_path(other_world) }
    end
  end
end
