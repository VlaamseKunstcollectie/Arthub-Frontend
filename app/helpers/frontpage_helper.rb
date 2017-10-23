# frozen_string_literal: true
module FrontpageHelper
  include ActionView::Helpers::NumberHelper

  def total_count

 	ftotal = number_with_delimiter(@total)

  	content_tag(:span, ftotal, :classes => ['total-count'])
  end
end
