module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  include FrontpageHelper

  # Overrides Blacklight::UrlHelperBehavior::url_for_document.
  #
  # This will remove the language part from the document.id
  #   i.e. en:groeningemuseum:000_1234_0 becomes groeningemuseum:000_1234_0
  # The language - 'en' or 'nl' - is fetched from the global locale. This assumes
  # that all values in the id field of the documents/records are prefixed with 
  # 'en:' or 'nl:'.
  #  
  # This method is called in order to create URL's for documents which will then
  # be used in clickble links. 
  # So http://arthub.vlaamsekunstcollectie.be/en/catalog/en:groeningemuseum:1234 
  # becomes http://arthub.vlaamsekunstcollectie.be/en/catalog/groeningemuseum:1234 
  # When the visitor clicks a link, another method will intercept the Solr query for
  # groeningemuseum:1234 and prefix it with the active locale (i.e 'en'). This will
  # make sure that the above URL will actually fetch the document with id 
  # 'en: groeningemuseum:1234' instead of 'groeningemuseum:1234'.
  #
  # Why the hassle? Because this all the same record, just in different languages.
  # It's kinda rendunant to expose the fact that the index uses 2 different solr documents
  # to model translations, when we're talking about the same record all-in-all.
  def url_for_document(document, options = {})
    document[:id] = document.id.gsub(/#{I18n.locale.to_s}:/, '')
    search_state.url_for_document(document, options)
  end

  # Implements the locale picker.
  # Depending on which page you're on, the 'en' and 'nl' options have to link 
  # their respective localised paths (either /nl/ or /en/) in order to show
  # the content in the correct language. 
  # 
  # Since we work with only a few static pages, and we don't have a database, 
  # we hard code a hash map here. If you add a new static page, don't forget to 
  # add the correct paths below.
  def locale_picker(locale)
    paths = {
        '/nl/collections' => '/nl/collecties',
        '/en/collecties' => '/en/collections',
        '/nl/how-to-use' => '/nl/handleiding',
        '/en/handleiding' => '/en/how-to-use',
        '/nl/open-data' => '/nl/open-gegevens',
        '/en/open-gegevens' => '/en/open-data',
        '/nl/open-source' => '/nl/open-bron',
        '/en/open-bron' => '/en/open-source',
        '/nl/contact-en' => '/nl/contact-nl',
        '/en/contact-nl' => '/en/contact-en',
        '/nl/legal-notification' => '/nl/juridische-kennisgeving',
        '/en/juridische-kennisgeving' => '/en/legal-notification'
    }

    url = url_for(locale: locale)
    
    # get rid of the 'en:' prefix if the id is en:groeningemuseum:1234
    url = url.gsub(/#{I18n.locale.to_s}:/, '')

    unless paths[url].nil?
        translated = paths[url]
        "#{translated}"
    else
        "#{url}"
    end
  end

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
        url: polymorphic_url(url_for_document(document), format: 'json', only_path: false),
    	link: true
    }

    @technical_details << {
        format: "LIDO XML",
        url: polymorphic_url(url_for_document(document), format: 'xml', only_path: false),
    	link: true
    }

    render partial: "catalog/technical_detail", collection: @technical_details
  end

  def render_iiif_manifest_url(document=@document, options = {})
     document.fetch(:manifest_url)
  end

  def link_to_repository(repository)
    host = url_for("http://"+request.host)
    if I18n.locale.to_s == "nl"
      locale = "nl"
    else
      locale = "en"
    end
    "#{host}/#{locale}/catalog?f%5Brepository%5D%5B%5D=#{repository}"
  end

  def render_meta_description(document=@document)
    meta_description = document.fetch(:description)
    "#{meta_description}"
  end

  def render_canonical_url
    url = url_for(:only_path => false)
    "#{url}"
  end

  def render_nl_url
    host = url_for("http://"+request.host)
    url = locale_picker("nl")
    "#{host}#{url}"
  end

  def render_en_url
    host = url_for("http://"+request.host)
    url = locale_picker("en")
    "#{host}#{url}"
  end

  def render_language_territory
    if I18n.locale.to_s == "nl"
        "nl_BE"
    else
        "en_GB"
    end
  end

  def render_alternate_language_territory
    if I18n.locale.to_s == "nl"
        "en_GB"
    else
        "nl_BE"
    end
  end

  def render_image(document=@document)
    # Strip out the locale again if it's present in order to fetch
    # the image based on the original document id (i.e. groeningemuseum:1234.jpg)
    id = document.id.gsub(/^#{I18n.locale.to_s}:/, '')
    riiif_image_url(id)
  end

end
