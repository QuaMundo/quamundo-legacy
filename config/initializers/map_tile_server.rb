module MapTileServer
  def self.url
    Rails.application.config_for(:maptile_server)[:url]
  end
end
