RSpec.describe 'Dashboard', type: :system do
  include_context 'Session'

  context 'for user without a world' do
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

  context 'for user with worlds' do
    let(:user) { build(:user_with_worlds_wo_img, worlds_count: 4) }

    it 'shows 4 last updated worlds' do
      visit root_path
      expect(page).to have_selector("div[id^=\"card-world-\"]", count: 4)
      world_ids = user.worlds.order(updated_at: :desc).limit(4)
        .all.map { |w| "card-world-#{w.id}" }
      world_ids.each do |id|
        expect(page).to have_selector("##{id}")
      end
      # Details are tested in world index view
    end

    it 'shows last 15 activities in descending order', :comprehensive do
      create_some_inventory(user)
      refresh_materialized_views(Inventory)
      visit root_path
      expect(page).to have_selector('#last-activities ul li', count: 15)
      user.inventories.limit(15).each do |entry|
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

