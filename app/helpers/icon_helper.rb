module IconHelper
  # Based on fontawesome
  def icon(type, *classes, &block)
    InventoryIcon.new(type).icon(*classes, &block)
  end

  def default_image(type, *classes)
    InventoryIcon.new(type).image(*classes)
  end

  class InventoryIcon
    include Webpacker::Helper
    include ActionView::Helpers

    def initialize(type)
      if type.is_a? String
        @type = type.downcase.to_sym
      elsif type.is_a? Symbol
        @type = type
      else
        @type = type.model_name.param_key.to_sym
      end
    end

    def image(*classes)
      fa_item = available_types[@type]
      style_path = fa_item[:style] == 'fas' ? 'solid' : 'regular'
      tag.img(
        src: asset_pack_path("media/#{style_path}/#{fa_item[:icon]}.svg"),
        class: classes
      ).html_safe
    end

    def icon(*classes, color: 'inherit', &block)
      css_classes = [
        "fa-#{available_types[@type][:icon]}",
        available_types[@type][:style]
      ] << classes
      # FIXME: Avoid inline style (maybe use classes?)
      html = '' << tag.i(class: css_classes, style: "color: #{color};")
      html << '&nbsp;' << yield if block_given?
      html.html_safe
    end

    private
    def available_types
      IconTypesHelper.available_types
    end
  end
end
