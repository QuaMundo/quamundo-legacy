module IconHelper
  # Based on fontawesome
  def icon(sym, style, *classes)
    html = ''
    block = yield if block_given?
    html << tag.i(class: [style, sym] << classes)
    html << '&nbsp;' << block if block
    html.html_safe
  end
end
