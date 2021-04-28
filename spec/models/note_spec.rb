# frozen_string_literal: true

RSpec.describe Note, type: :model do
  include_context 'Session'

  let(:note) { build(:world_with_notes).notes.first }

  it 'must have content' do
    note.content = nil
    expect { note.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(note).not_to be_valid
  end

  it_behaves_like 'updates parents' do
    let(:parent)  { create(:world) }
    let(:subject) { create(:note, noteable: parent) }
  end
end
