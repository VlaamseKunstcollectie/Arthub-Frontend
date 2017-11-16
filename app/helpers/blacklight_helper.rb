module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  include FrontpageHelper

  def render_technical_details(document=@document, options = {})
    return if document.nil?    
    @technical_details = []

    @technical_details << {
    	format: "Permalink",
    	url: solr_document_url(@document),
    	link: true
    }

    @technical_details << {
    	format: "Work PURL",
    	url: document.fetch(:work_pid),
    	link: false
    }

    @technical_details << {
    	format: "Data PURL",
    	url: document.fetch(:data_pid),
    	link: true
    }

    @technical_details << {
        format: "JSON",
        url: polymorphic_url(url_for_document(@document), format: 'json', only_path: false),
    	link: true
    }

    @technical_details << {
        format: "LIDO XML",
        url: polymorphic_url(url_for_document(@document), format: 'xml', only_path: false),
    	link: true
    }

    render partial: "catalog/technical_detail", collection: @technical_details
  end
end
