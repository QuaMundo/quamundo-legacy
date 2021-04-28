# frozen_string_literal: true

RSpec.shared_examples 'inventory', type: :model do
  let(:image_file)    { "#{subject.model_name.to_s.downcase}.jpg" }
  let(:subject_world) { subject.world }
  let(:klass)         { subject.class }
  let(:method)        { subject.model_name.plural.to_s.downcase.to_sym }

  it 'can get an image attached' do
    attach_file(subject.image, image_file)
    subject.save!
    expect(subject.image).to be_attached
  end

  it 'can only be created in context of a world' do
    subject.world = nil
    expect(subject).not_to be_valid
  end

  it 'is indirectly linked to a user' do
    subject.save
    expect(world.user.send(method)).to include(subject)
    expect(subject.user).to eq(world.user)
  end

  it 'refuses to change references to it\'s world' do
    subject.save
    old_world_id = subject.world_id
    subject.world_id = create(:world, user: user).id
    subject.save
    subject.reload
    expect(subject.world_id).to eq(old_world_id)
    # DB exception not thrown since attribute is read-only in rails!
    # expect { subject.save! }
    #   .to raise_error ActiveRecord::StatementInvalid
  end
end
