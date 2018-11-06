shared_examples_for "i18ned" do
  it 'is completely i18ned' do
    visit path
    expect(page).not_to have_selector('span.translation_missing')
  end
end
