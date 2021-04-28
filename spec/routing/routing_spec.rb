# frozen_string_literal: true

RSpec.describe 'Routes for Quamundo', type: :routing do
  include_context 'Session'

  context 'Dashboard' do
    it 'routes root to dashboard' do
      expect(get('/')).to route_to('dashboard#index')
    end
  end

  context 'Worlds' do
    it 'routes /worlds to worlds index' do
      expect(get('/worlds')).to route_to('worlds#index')
    end
  end
end
