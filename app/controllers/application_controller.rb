class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_locale

  verify_authorized

  def default_url_options
    I18n.default_locale == I18n.locale ? {} : { l: I18n.locale }
  end

  private
  def set_locale
    I18n.locale = params[:l] || params[:locale] || get_locale_from_tld || I18n.default_locale
  end

  def get_locale_from_tld
    tld = request.host.split('.').last
    I18n.available_locales.map(&:to_s).include?(tld) ? tld : nil
  end
end
