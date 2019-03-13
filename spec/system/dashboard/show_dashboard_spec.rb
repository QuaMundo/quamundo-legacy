RSpec.describe 'Dashboard', type: :system do
  include_context 'Session'

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
    let(:user) { create(:user_with_worlds_wo_img, worlds_count: 7) }

    around(:example) do |example|
      sign_in(user)
      visit root_path
      example.run
      sign_out(user)
    end

    # FIXME: Make shared_examples of this!
    it 'shows 4 last updated worlds' do
      expect(page).to have_selector("div[id^=\"card-world-\"]", count: 4)
      world_ids = user.worlds.order(updated_at: :desc).limit(4)
        .all.map { |w| "card-world-#{w.id}" }
      world_ids.each do |id|
        expect(page).to have_selector("##{id}")
      end
      # Details are tested in world index view
    end

    it 'shows 4 last updated figures' do
      expect(page).to have_selector("div[id^=\"card-figure-\"]", count: 4)
      figure_ids = user.figures.order(updated_at: :desc).limit(4)
        .all.map { |f| "card-figure-#{f.id}" }
      figure_ids.each do |id|
        expect(page).to have_selector("##{id}")
      end
      # Details are tested in world index view
    end

    it_behaves_like "valid_view" do
      let(:subject) { root_path }
    end
  end
end

