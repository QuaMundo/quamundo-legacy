# frozen_string_literal: true

RSpec.shared_examples 'associated traits', type: :system do
  let(:path) { [subject.try(:world), subject].compact }

  before(:example) do
    subject.save
  end

  context 'in show views' do
    it 'lists all attributes' do
      visit(polymorphic_path(path))
      expect(page).to have_selector('.attributeset-key',
                                    count: subject.trait.attributeset.count)
      expect(page).to have_selector('.attributeset-value',
                                    count: subject.trait.attributeset.count)
    end
  end
end
