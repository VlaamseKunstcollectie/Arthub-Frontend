# frozen_string_literal: true
class PagesController < ApplicationController
  # Do not prepend 'en:' to the document.id. Only do this for the catalog controller!
  skip_before_action :switch_locale_of_document_id

  protect_from_forgery with: :exception
  include HighVoltage::StaticPage
  
  layout 'blacklight'
end
