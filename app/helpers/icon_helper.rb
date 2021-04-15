# frozen_string_literal: true

module IconHelper
  # Based on fontawesome
  def icon(type, *classes, &block)
    InventoryIcon.new(type).icon(*classes, &block)
  end

  def default_image(type, *classes)
    InventoryIcon.new(type).image(*classes)
  end

  class InventoryIcon
    # rubocop:disable Rails/HelperInstanceVariable
    include Webpacker::Helper
    include ActionView::Helpers

    def initialize(type)
      @type = case type
              when String
                type.downcase.to_sym
              when Symbol
                type
              else
                type.model_name.param_key.to_sym
              end
    end

    def image(*classes)
      fa_item = available_types[@type]
      style_path = fa_item[:style] == 'fas' ? 'solid' : 'regular'
      tag.img(
        src: asset_pack_path("media/#{style_path}/#{fa_item[:icon]}.svg"),
        class: classes
      )
    end

    def icon(*classes, color: 'inherit')
      css_classes = [
        "fa-#{available_types[@type][:icon]}",
        available_types[@type][:style]
      ] << classes
      color = sanitize("color: #{color};")
      # FIXME: Avoid inline style (maybe use classes?)
      i_tag = tag.i(class: css_classes, style: color)
      block = yield if block_given?
      html = "#{i_tag}&nbsp;#{block if block.presence}"
      # FIXME: Sanitize seems to strip off color style
      sanitize(html)
    end

    private

    def available_types
      IconTypesHelper.available_types
    end
    # rubocop:enable Rails/HelperInstanceVariable
  end
end
