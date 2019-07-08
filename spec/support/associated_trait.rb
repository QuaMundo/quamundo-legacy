RSpec.shared_examples 'associated traits', type: :system do
  let(:path) { [subject.try(:world), subject].reject(&:nil?) }

  before(:example) do
    subject.save
  end

  context 'in show views' do
    before(:example) do
      visit(polymorphic_path(path))
      # open the collapse
      page.find('#traits-header button').click
    end

    it 'lists all attributes' do
      expect(page).to have_selector('.attributeset-key',
                                    count: subject.trait.attributeset.count)
      expect(page).to have_selector('.attributeset-value',
                                    count: subject.trait.attributeset.count)
    end

    it 'provides link to edit' do
      page.find("a#edit-trait-#{subject.trait.id}").click
      expect(page).to have_current_path(edit_trait_path(subject.trait))
    end

    it 'provides link to delete', :js, :comprehensive do
      res = page.accept_confirm do
        page.find("a#delete-trait-#{subject.trait.id}").click
      end
      expect(res).not_to match(/translation missing/i)
      expect(page).to have_current_path(polymorphic_path(path))
      expect(page).to have_selector('.attributeset-key', count: 0)
      expect(page).to have_selector('.attributeset-value', count: 0)
      subject.reload
      expect(subject.trait.attributeset).to be_empty
    end
  end

  context 'CRUD actions' do
    it 'change existing attributes' do
      add_trait
      visit(edit_trait_path(subject.trait))
      expect(page).to have_selector('label', text: 'new_key')
      fill_in('trait_attributeset_new_key', with: 'changed')
      click_button('submit')
      expect(page).to have_current_path(polymorphic_path(path))
      expect(page).to have_selector('.attributeset-key', text: 'new_key')
      expect(page).to have_selector('.attributeset-value', text: 'changed')
    end

    it 'add a new attribute' do
      visit(edit_trait_path(subject.trait))
      expect(page)
        .to have_content("#{subject.model_name.human.capitalize} \"#{subject.try(:name) || subject.try(:title)}\"")
      fill_in('trait_new_key', with: 'another_new_key')
      fill_in('trait_new_value', with: 'another new value')
      click_button('submit')
      expect(page).to have_current_path(polymorphic_path(path))
      expect(page)
        .to have_selector('.attributeset-key', text: 'another_new_key')
      expect(page)
        .to have_selector('.attributeset-value', text: 'another new value')
    end

    it 'removes attribute without value' do
      add_trait
      visit(edit_trait_path(subject.trait))
      fill_in('trait_attributeset_new_key', with: '')
      click_button('submit')
      expect(page).to have_current_path(polymorphic_path(path))
      expect(page).not_to have_selector('td.attributeset-key', text: 'new_key')
    end

    it 'can remove a single attribute by delete link' do
      pending
      add_trait
      visit(edit_trait_path(subject.trait))
      click_link('trait_attributeset_delete_new_key')
    end

    private
    def add_trait
      subject.trait.attributeset.store(:new_key, 'a new value')
      subject.trait.save
    end
  end
end
