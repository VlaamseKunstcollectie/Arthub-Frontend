# frozen_string_literal: true
class PagesController < ApplicationController
  protect_from_forgery with: :exception
  include HighVoltage::StaticPage
  
  layout 'blacklight'
end