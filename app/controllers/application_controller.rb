class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout 'blacklight'

  skip_after_action :discard_flash_if_xhr

  # Executed before a controller action is executed.
  #
  # Modifies the HTTP Query parameters before they are passed on
  # to controller actions
  #
  # Based on the /:locale/catalog/... parameter, set the global I18n.locale 
  # variable
  before_action :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Executed before a controller action is executed.
  #
  # Modifies the HTTP Query parameters before they are passed on
  # to controller actions
  #
  # If the locale in /:locale/catalog/:id is 'en', then you need 
  # to transform the 'id' parameter before passing it onto the action.
  #
  #  groeningemuseum:1234 will become en:groeningemuseum:1234
  # 
  # This will ensure that depending on the locale, the correct translated
  # Solr document will be fetched from the Solr index, without exposing 
  # to the outside world that the index contains multiple documents.
  before_action :switch_locale_of_document_id
  def switch_locale_of_document_id
   if (params.has_key?(:id))
      params[:id].prepend("#{I18n.locale}:")
   end
  end

  # app/controllers/application_controller.rb
  def default_url_options
    { locale: I18n.locale }
  end

  protect_from_forgery with: :exception
end
