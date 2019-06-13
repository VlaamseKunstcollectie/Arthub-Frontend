# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document    
  
  field_semantics.merge!(    
                         :title => "title_display",
                         :author => "author_display",
                         :language => "language_facet",
                         :format => "format"
                         )

  # Accessor for the Solr document model
  #
  # This will set the :id property of the Solr Document to
  # the correct version depending on the locale. 
  # "en:groeningemuseum:1234" will become "groeningemuseum:1234"
  #
  # This method needs to be called explicitly from controllers, concerns,...
  def set_id_on_locale
    id = self[:id].gsub(/^#{I18n.locale.to_s}:/, '')
    self[:id] = id
  end

  # Email uses the semantic field mappings below to generate the body of an email.
  # SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  # SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)
  use_extension(Blacklight::Document::Lido)
end
