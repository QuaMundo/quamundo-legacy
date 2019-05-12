RSpec.describe 'Dashboard', type: :system do
  include_context 'Session'

  context 'for user without a world', login: :user do
    before(:example) { visit root_path }

    it 'shows invitation to create a world' do
      page.within('.jumbotron') do
        click_link('create a world', href: new_world_path)
      end
      expect(page).to have_current_path(new_world_path)
    end

    it_behaves_like "valid_view" do
      let(:subject) { root_path }
    end
  end

  context 'for user with worlds', login: :other_user_with_worlds do
    before(:example) { visit root_path }

    it 'shows 4 last updated worlds' do
      expect(page).to have_selector("div[id^=\"card-world-\"]", count: 4)
      world_ids = other_user_with_worlds.worlds.order(updated_at: :desc).limit(4)
        .all.map { |w| "card-world-#{w.id}" }
      world_ids.each do |id|
        expect(page).to have_selector("##{id}")
      end
      # Details are tested in world index view
    end

    it 'shows last 15 activities in descending order', :comprehensive do
      create_some_inventory(other_user_with_worlds)
      other_user_with_worlds.dashboard_entries.each do |entry|
        check_attrs(entry)
      end
    end

    it_behaves_like "valid_view" do
      let(:subject) { root_path }
    end

    private
    def check_attrs(item)
      expect(page).to have_content(item.name)
      expect(page).to have_content(item.description)
      expect(page).to have_link(
        href: polymorphic_path([item.world, item.inventory])
      )
      expect(page).to have_selector('img')
    end
  end
end

