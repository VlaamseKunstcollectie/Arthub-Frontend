class ImagesController < ApplicationController
    # don't prepend 'en:' to the document.id. Only do this for the catalog controller!
    skip_before_action :switch_locale_of_document_id

    include Blacklight::Catalog

    def manifest    
      @response, @document = fetch params[:id]

      image_id = @document.fetch(:publish_image) ? params[:id] : 'arthub:placeholder'

      # Check if valid image
      # Set CORS allowed header
      artefact = Riiif::Image.new(image_id)

      seed = {
          '@id' => riiif_manifest_url(image_id),
          'label' => @document.fetch(:title_display)
      }

      # service = IIIF::Presentation::Resource.new('@id' => "http://" + SecureRandom.uuid)
      service = IIIF::Presentation::Resource.new('@id' => riiif_base_url(image_id))
      service['@context'] = "http://iiif.io/api/image/2/context.json"
      service['profile'] = "http://iiif.io/api/image/2/level2.json"

      manifest = IIIF::Presentation::Manifest.new(seed)

      manifest['metadata'] = Array.new

      manifest['metadata'] << {
        'label': 'title',
        'value': @document.fetch(:title_display)
      }

      manifest['metadata'] << {
        'label': 'creator',
        'value': @document.fetch(:creator_display)
      }

      manifest['metadata'] << {
        'label': 'production date',
        'value': @document.fetch(:production_date)
      }

      # logo
      logoService = IIIF::Presentation::Resource.new('@id' => "http://" + SecureRandom.uuid)
      logoService['@context'] = "http://iiif.io/api/image/2/context.json"
      logoService['profile'] = "http://iiif.io/api/image/2/level2.json"

      logoUrl = view_context.image_path('logo-arthub.jpg')

      repository = @document.fetch(:repository)
      publish_image = @document.fetch(:publish_image)

        manifest['license'] = "http://rightsstatements.org/vocab/CNE/1.0/"

        if (I18n.locale == :en)
          manifest['attribution'] = <<~HEREDOC
            The evaluation of the copyright for this work and its electronic representations is ongoing. 
            Rightsholders are kindly invited to reach out to us and direct corrections via email to info@vlaamsekunstcollectie.be.
            For higher resolution images suitable for scholarly or commercial publication, either in print or in an electronic format, please contact #{repository} directly.
            HEREDOC
        else
          manifest['attribution'] = <<~HEREDOC
          De evaluatie van de auteursrechten voor dit werk en haar electronische representaties is gaande.
          Rechthebbenden worden vriendelijk verzocht om correspondentie te richten via e-mail aan info@vlaamsekunstcollectie.be.
          Voor kopiën op hoge resolutie voor educatieve of commerciële publicatie, zowel in print als digitaal formaat, kan u #{repository} rechtstreeks contacteren.
          HEREDOC
        end

      manifest['logo'] =  {
        "@id": logoUrl,
        "service": logoService
      }

      thumbnail = IIIF::Presentation::Resource.new(
          '@id' => riiif_image_url(id: image_id, size: '400,400')
      )
      thumbnail['@type'] = 'dctypes:Image'
      thumbnail['format'] = 'image/jpeg'
      thumbnail['service'] = service
      manifest['thumbnail'] = thumbnail

      # @todo Create a thumbnail

      canvas = IIIF::Presentation::Canvas.new()
      sequence = IIIF::Presentation::Sequence.new()

      sequence['@id'] = @document.fetch(:data_pid)
      sequence['@type'] = 'sc:Sequence'
      sequence['label'] = 'Current order'
      sequence['viewingDirection'] = "left-to-right"

      canvas_id = "http://" + SecureRandom.uuid
      canvas['@id'] = canvas_id
      canvas['width'] = artefact.info.width
      canvas['height'] = artefact.info.height
      canvas['label'] = "Image 1"

      # image = IIIF::Presentation::Resource.new('@id' => "http://" + SecureRandom.uuid)
      image = IIIF::Presentation::Resource.new('@id' => "http://" + SecureRandom.uuid)
      image['@type'] = 'oa:Annotation'
      image['motivation'] = 'sc:painting'
      image['on'] = canvas_id  

      resource = IIIF::Presentation::Resource.new('@id' => riiif_image_url(image_id))
      resource['@type'] = 'dctypes:Image'
      resource['format'] = 'image/jpeg'
      resource['width'] = artefact.info.width
      resource['height'] = artefact.info.height

      resource['service'] = service
      image['resource'] = resource
      canvas['images'] = [ image ]
      sequence['canvases'] = [ canvas ]     
      manifest.sequences << sequence
   
      render json: manifest.to_json(pretty: true)

    end

end 