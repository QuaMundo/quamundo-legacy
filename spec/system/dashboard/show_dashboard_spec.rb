RSpec.describe 'Dashboard', type: :system do
  include_context 'Session'
  include_context 'Worlds'

  context 'for user without a world', login: :user do
    before(:example) { visit root_path }

    it 'shows invitation to create a world' do
      page.within('.jumbotron') do
        click_link('create a world', href: new_world_path)
      end
      expect(current_path).to eq(new_world_path)
    end

    it_behaves_like "valid_view" do
      let(:subject) { root_path }
    end
  end

  context 'for user with worlds' do
    # FIXME: There should be a shared_context for this!
    let(:user) { create(:user_with_worlds_wo_img, worlds_count: 5) }

    around(:example) do |example|
      sign_in(user)
      visit root_path
      example.run
      sign_out(user)
    end

    it 'shows 4 last updated worlds' do
      expect(page).to have_selector("div[id^=\"card-world-\"]", count: 4)
      world_ids = user.worlds.order(updated_at: :desc).limit(4)
        .all.map { |w| "card-world-#{w.id}" }
      world_ids.each do |id|
        expect(page).to have_selector("##{id}")
      end
      # Details are tested in world index view
    end

    it 'shows last 15 activities in descending order' do
      create_some_inventory(user)
      page.within('#last-activities') do
        user.dashboard_entries.each do |entry|
          expect(page).to have_content(entry.name)
          expect(page).to have_content(entry.description)
          expect(page).to have_link(
            href: polymorphic_path([entry.world, entry.inventory])
          )
          expect(page).to have_selector('img')
          # FIXME: Further details ...
        end
      end
    end

    it_behaves_like "valid_view" do
      let(:subject) { root_path }
    end
  end
end

