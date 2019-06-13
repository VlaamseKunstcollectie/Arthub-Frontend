# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end

  # Hook the callback function 'limit_language' to the solr search processor chain.
  self.default_processor_chain += [:limit_language]

  # Callback function that gets thrown in the search query processor chain.
  # 
  # Depending on the locale (en, or nl) the search query will automagically
  # trigger the "Language" facet. This facet will search on the 'language_ssi'
  # solr field via the solr parameter 'fq'.
  #
  # This function will always be executed when performing searches.
  def limit_language(solr_params)
    languages = {
      'en' => 'English',
      'nl' => 'Dutch'
    }

    language = languages.fetch("#{I18n.locale}")

    solr_params[:fq] << "{!raw f=language_ssi}#{language}"
  end
end
