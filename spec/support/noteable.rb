RSpec.shared_examples 'noteable', type: :model do
  let(:assoc_obj)     { subject.model_name.to_s.downcase.to_sym }

  it 'has a list of notes' do
    expect(subject).to respond_to(:notes)
    notes = []
    3.times do
      note = build(:note, noteable: subject)
      notes << note
      subject.notes << note
    end
    subject.save
    expect(Note.ids).to include(*notes.map(&:id))
  end

  it 'deletes all notes when subject is deleted' do
    obj = create(assoc_obj, world: world)
    note_ids = obj.note_ids
    expect(Note.ids).to include(*note_ids)
    obj.destroy!
    expect(Note.ids).not_to include(*note_ids)
  end
end
