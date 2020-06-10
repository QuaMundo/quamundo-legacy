RSpec.describe 'Icon helper', type: :helper do
  let(:icons) {
    {
      World   => 'globe',
      User    => 'user',
      Figure  => 'user',
      Item    => 'wrench'
    }
  }

  context 'as a model icon helper' do
    it 'renders html code for icon' do
      icons.each do |icon, name|
        expect(helper.icon(icon))
          .to match /<i class="fa-#{name} .+"><\/i>/
      end
    end

    it 'renders html code for icon with additional classes' do
      icons.each do |icon, name|
        expect(helper.icon(icon, 'a', 'b', 'c'))
          .to match /<i class="fa-#{name} .+a b c".*><\/i>/
      end
    end

    it 'renders html code for icon with additional html' do
      icons.each do |icon, name|
        expect(
          helper.icon(icon) { 'Hallo Welt!' }
        ).to match /<i class="fa-#{name} .+"><\/i>&nbsp;Hallo Welt!/
      end
    end
  end

  context 'as a default image helper' do
    it 'shows default images by class' do
      icons.each do |icon, name|
        expect(helper.default_image(icon, 'a', 'b'))
          .to match /<img src=".+#{name}.*\.svg"\s+class="a b".*\/?>/
      end
    end

    it 'shows default images by object' do
      icons.each do |icon, name|
        expect(helper.default_image(icon.new, 'a', 'b'))
          .to match /<img src=".+#{name}.*\.svg"\s+class="a b".*\/?>/
      end
    end

    it 'shows default images choosen by string' do
      icons.each do |icon, name|
        expect(helper.default_image(icon.to_s, 'a', 'b'))
          .to match /<img src=".+#{name}.*\.svg"\s+class="a b".*\/?>/
      end
    end
  end
end
