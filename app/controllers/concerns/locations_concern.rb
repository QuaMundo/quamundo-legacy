# frozen_string_literal: true

module LocationsConcern
  extend ActiveSupport::Concern

  included do
    # prepare json object of a location
    # FIXME: Should be refactored
    def location_json(location)
      location.map do |loc|
        # Add some computed attributes to json ajax response
        loc.attributes.merge(
          { 'url' => world_location_path(loc.world, loc),
            # FIXME: Better use card_img_helper which is not available!?
            'img' => loc.image.attached? ? url_for(loc.image) : '',
            'lat' => loc.lat,
            'lon' => loc.lon }
        )
      end
    end
  end
end
