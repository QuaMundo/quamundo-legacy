# frozen_string_literal: true

RSpec.describe Dossier, type: :model do
  include_context 'Session'

  let(:dossier) { build(:dossier, dossierable: build(:world, user: user)) }

  it 'must have a name' do
    dossier.name = nil
    expect { dossier.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(dossier).not_to be_valid
  end

  it 'can get files attached' do
    expect(dossier.images.count).to eq 0
    expect(dossier.audios.count).to eq 0
    expect(dossier.videos.count).to eq 0
    expect(dossier.other_files.count).to eq 0
    expect(dossier.files.attached?).to be_falsey
    attach_file(dossier.files, 'file.pdf')
    expect(dossier.files.attached?).to be_truthy
    attach_file(dossier.files, 'video.m4v')
    attach_file(dossier.files, 'earth.jpg')
    attach_file(dossier.files, 'audio.mp3')
    expect(dossier.files.attachments.size).to eq(4)
    expect(dossier.images.count).to eq 1
    expect(dossier.audios.count).to eq 1
    expect(dossier.videos.count).to eq 1
    expect(dossier.other_files.count).to eq 1
  end

  it 'can remove attached files' do
    %w[video.m4v earth.jpg audio.mp3].each { |f| attach_file(dossier.files, f) }
    dossier.save!
    expect(dossier.files.count).to eq(3)
    dossier.files.first.purge
    expect(dossier.files.count).to eq(2)
  end

  it_behaves_like 'updates parents' do
    let(:parent) { create(:world) }
    let(:subject) { create(:dossier, dossierable: parent) }
  end
end
