RSpec.describe Tag, type: :model do
  #include_context 'Session'

  let(:world) { build(:world_with_tags) }
  let(:tag) { world.tag }

  context 'presence' do
    it 'must have a list of tags' do
      expect(tag.tagset).to be_an Array
      tag.tagset = []
      expect(tag).to be_valid
    end
  end

  context 'validation fo tags' do
    it 'ensures all tags are in lower and snake-case' do
      tag.tagset = %w{ hAllo\ wElT one double tWo THREE double aüöä-= }
      tag.validate
      expect(tag.tagset).to eq(%w{ auoa- double hallo_welt one three two })
    end

    it 'is true for empty tagset' do
      tag.tagset = []
      expect(tag).to be_valid
    end

    it 'handles one element tagsets right' do
      tag.tagset = %w{one_tag}
      expect(tag).to be_valid
    end
  end

  it_behaves_like 'updates parents' do
    let(:parent)  { create(:world_with_tags) }
    let(:subject) { parent.tag }
  end
end
