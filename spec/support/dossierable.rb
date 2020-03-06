RSpec.shared_examples 'dossierable', type: :model do
  before(:example) do
    subject.save!
    3.times do |i|
      subject.dossiers.create(name: "Dossier #{i}", content: "Content #{i}")
    end
    expect(subject.dossiers.count).to be >= 3
  end

  it 'has a list of dossiers' do
    dossiers = subject.dossiers.ids
    expect(Dossier.ids).to include(*dossiers)
  end

  it 'deletes all dossiers when subject is deleted' do
    dossiers = subject.dossiers.ids
    expect(Dossier.ids).to include(*dossiers)
    subject.destroy!
    expect(Dossier.ids).not_to include(*dossiers)
  end
end
