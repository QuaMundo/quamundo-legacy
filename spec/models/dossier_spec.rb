RSpec.describe Dossier, type: :model do
  include_context 'Session'

  let(:dossier) { build(:dossier) }

  it 'must have content' do
    dossier.content = nil
    expect { dossier.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(dossier).not_to be_valid
  end

  it 'must have a title' do
    dossier.title = nil
    expect { dossier.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(dossier).not_to be_valid
  end

  it 'can get files attached' do
    expect(dossier.files.attached?).to be_falsey
    attach_file(dossier.files, 'file.pdf')
    expect(dossier.files.attached?).to be_truthy
    attach_file(dossier.files, 'video.m4v')
    expect(dossier.files.attachments.size).to eq(2)
  end

  it_behaves_like 'updates parents' do
    let(:parent) { create(:world) }
    let(:subject) { create(:dossier, dossierable: parent) }
  end
end
