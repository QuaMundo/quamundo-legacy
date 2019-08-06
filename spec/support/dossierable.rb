RSpec.shared_examples 'dossierable', type: :model do
  let(:assoc_obj) { subject.model_name.to_s.downcase.to_sym }

  it 'gets a default dossier after creation' do
    obj = create(assoc_obj, world: build(:world))
    expect(obj.dossiers.count).to eq(1)
    expect(obj.dossiers.first.name).to eq(obj.name)
  end

  it 'has a list of dossiers' do
    dossiers = []
    3.times do
      dossier = build(:dossier, dossierable: subject)
      dossiers << dossier
      subject.dossiers << dossier
    end
    subject.save
    expect(Dossier.ids).to include(*dossiers.map(&:id))
  end

  it 'deletes all dossiers when subject is deleted' do
    obj = create(assoc_obj, world: world)
    obj.dossiers << create(:dossier, dossierable: obj)
    dossier_ids = obj.dossier_ids
    expect(Dossier.ids).to include(*dossier_ids)
    obj.destroy!
    expect(Dossier.ids).not_to include(*dossier_ids)
  end
end
