RSpec::Matchers.define :be_i18n_ready do |expected|
  match do |actual|
    actual.has_selector?('.translation_missing', count: 0) &&
      actual.has_selector?('[titel*="translation_missing"]', count: 0) &&
      actual.has_content?(/translation missing/i, count: 0)
  end

  description do
    'is completely translated (i18n)'
  end

  failure_message do
    missing = get_by_class(actual) || get_by_title(actual) || get_by_text(actual)
    <<~EOM
    expected content to be completely translated, but it isn't

    Missing translation for: #{missing.text}

    [#{missing.inspect}]
    EOM
  end

  failure_message_when_negated do
    "expected page not to be completely translated, but it is"
  end

  private
  def get_by_class content
    content.find('.translation_missing') if content.has_css?('.translation_missing')
  end

  def get_by_title content
    if content.has_selector?('[title*="translation_missing"]')
      content.find('[title*="translation_missing"]')
    end
  end

  def get_by_text content
    content.first('*', text: /translation missing/i)
  end
end

RSpec::Matchers.define :have_i18n_ready_dialogs do |expected = 'a[title="delete"]'|
  match do |actual|
    if actual.has_selector?(expected)
      dialog = actual.accept_confirm {
        page.first(expected).click
      }
      !dialog.match /translation missing/i
    else
      true
    end
  end
end
