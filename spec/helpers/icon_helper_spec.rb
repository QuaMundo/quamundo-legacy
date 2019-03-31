RSpec.describe 'Icon helper', type: :helper do
  let(:icons) {
    {
      World   => 'globe',
      User    => 'user',
      Figure  => 'user',
      Item    => 'wrench'
    }
  }

  context 'as simple icon helper' do
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

  context 'as a model icon helper' do
    it 'renders html code for icon' do
      icons.each do |icon, name|
        expect(helper.qm_icon(icon))
          .to match /<i class="fa-#{name} .+"><\/i>/
      end
    end

    it 'renders html code for icon with additional classes' do
      icons.each do |icon, name|
        expect(helper.qm_icon(icon, 'a', 'b', 'c'))
          .to match /<i class="fa-#{name} .+a b c"><\/i>/
      end
    end

    it 'renders html code for icon with additional html' do
      icons.each do |icon, name|
        expect(
          helper.qm_icon(icon) { 'Hallo Welt!' }
        ).to match /<i class="fa-#{name} .+"><\/i>&nbsp;Hallo Welt!/
      end
    end
  end

  context 'as a default image helper' do
    it 'shows default images by class' do
      icons.each do |icon, name|
        expect(helper.default_image(icon))
          .to match /#{name}.*\.svg/
      end
    end

    it 'shows default images by object' do
      icons.each do |icon, name|
        expect(helper.default_image(icon.new))
          .to match /#{name}.*\.svg/
      end
    end

    it 'shows default images choosen by string' do
      icons.each do |icon, name|
        expect(helper.default_image(icon.to_s))
          .to match /#{name}.*\.svg/
      end
    end
  end
end
