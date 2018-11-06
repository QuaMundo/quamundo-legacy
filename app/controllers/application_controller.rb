class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :authenticate_user!, :set_locale

  def default_url_options
    I18n.default_locale == I18n.locale ? {} : { l: I18n.locale }
  end

  private
  def set_locale
    I18n.locale = params[:l] || params[:locale] || I18n.default_locale
  end
end
