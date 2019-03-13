RSpec.describe 'Icon helper', type: :helper do
  context 'as simple helper' do
    it 'creates an fa icon' do
      expect(helper.icon('fa-globe', 'fas'))
        .to eq('<i class="fas fa-globe"></i>')
    end

    it 'accepts additional classes' do
      expect(helper.icon('fa-globe', 'fas', 'a', 'b', 'c'))
        .to eq('<i class="fas fa-globe a b c"></i>')
    end

    it 'renders additional html if block given' do
      expect { |html| helper.icon('fa-globe', 'fas', &html) }
        .to yield_control
      expect(
        helper.icon('fa-globe', 'fas', 'my_class') { |c| "Hallo Welt" }
      ).to eq('<i class="fas fa-globe my_class"></i>&nbsp;Hallo Welt')
    end
  end
end
