RSpec.describe Note, type: :model do
  include_context 'Session'

  let(:note) { build(:note, noteable: create(:world)) }

  it 'must have content' do
    note.content = nil
    expect { note.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(note).not_to be_valid
  end

  it_behaves_like 'updates parents' do
    let(:subject) { note }
    let(:parent)  { note.noteable }
  end
end
