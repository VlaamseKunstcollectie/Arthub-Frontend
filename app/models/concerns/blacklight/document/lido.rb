require 'nokogiri'

# This module provide Dublin Core export based on the document's semantic values
module Blacklight::Document::Lido
  
  def self.extended(document)
    # Register our exportable formats
    Blacklight::Document::Lido.register_export_formats( document )
  end

  def self.register_export_formats(document)
    document.will_export_as(:xml, "text/xml")
    document.will_export_as(:lido_xml, "application/lido+xml")
  end

  def export_as_oai_lido_xml
    raw = self.fetch(:xml)

    @doc = Nokogiri::XML(raw)
    id = @doc.at("//lido:lido/lido:lidoRecID[@lido:type='urn']")
    id.content = "arthub.vlaamsekunstcollectie.be:" + self.fetch(:id)
    @doc.to_xml
  end

  alias_method :export_as_xml, :export_as_oai_lido_xml
  alias_method :export_as_lido_xml, :export_as_oai_lido_xml

end
