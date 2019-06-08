RSpec.shared_examples 'dossierable', type: :model do
  let(:assoc_obj) { subject.model_name.to_s.downcase.to_sym }

  it 'has a list of dossiers' do
    expect(subject).to respond_to(:dossiers)
    dossiers = []
    3.times do
      dossier = build(:dossier, dossierable: subject)
      dossiers << dossier
      subject.dossiers << dossier
    end
    subject.save
    expect(Dossier.all.map(&:id)).to include(*dossiers.map(&:id))
  end

  it 'deletes all dossiers when subject is deleted' do
    obj = create(assoc_obj, world: world)
    dossier_ids = obj.dossier_ids
    expect(Dossier.all.map(&:id)).to include(*dossier_ids)
    obj.destroy!
    expect(Dossier.all.map(&:id)).not_to include(*dossier_ids)
  end
end
