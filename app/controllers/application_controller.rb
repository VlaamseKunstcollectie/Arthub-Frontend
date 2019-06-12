class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout 'blacklight'

  skip_after_action :discard_flash_if_xhr

  before_action :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # app/controllers/application_controller.rb
  def default_url_options
    { locale: I18n.locale }
  end

  protect_from_forgery with: :exception
end
