module IconHelper
  # Based on fontawesome
  # FIXME: Treat this as deprecated
  def icon(sym, style, *classes)
    block = yield if block_given?
    html = '' << tag.i(class: [style, sym] << classes)
    html << '&nbsp;' << block if block
    html.html_safe
  end

  def default_image(type)
    InventoryIcon.new(type).image
  end

  def qm_icon(type, *classes, &block)
    InventoryIcon.new(type).icon(*classes, &block)
  end

  class InventoryIcon
    include Webpacker::Helper
    include ActionView::Helpers

    def initialize(type)
      if type.is_a? String
        @type = type.downcase.to_sym
      else
        @type = type.model_name.param_key.to_sym
      end
    end

    def image
      fa_item = available_types[@type]
      style_path = fa_item[:style] == 'fas' ? 'solid' : 'regular'
      asset_pack_path("media/#{style_path}/#{fa_item[:icon]}.svg")
    end

    def icon(*classes, &block)
      html = '' << tag.i(class: ["fa-#{available_types[@type][:icon]}",
                                 available_types[@type][:style] ] << classes)
      html << '&nbsp;' << yield if block_given?
      html.html_safe
    end

    private
    def available_types
      # FIXME: Find the right place for this!
      {
        world:    { icon: 'globe',      style: 'fas' },
        figure:   { icon: 'user',       style: 'fas' },
        user:     { icon: 'user',       style: 'fas' },
        item:     { icon: 'wrench',     style: 'fas' }
      }
    end
  end
end
