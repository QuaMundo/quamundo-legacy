# frozen_string_literal: true

RSpec.shared_examples 'noteable', type: :model do
  before(:example) do
    subject.save!
    3.times { |i| subject.notes.create(content: "Note: #{i}") }
  end

  it 'has a list of notes' do
    expect(subject).to respond_to(:notes)
    notes = subject.notes.ids
    subject.save
    expect(Note.ids).to include(*notes)
  end

  it 'deletes all notes when subject is deleted' do
    notes = subject.notes.ids
    expect(Note.ids).to include(*notes)
    subject.destroy!
    expect(Note.ids).not_to include(*notes)
  end
end
