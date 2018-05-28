class ImagesController < ApplicationController
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
      image = IIIF::Presentation::Resource.new('@id' => "http://bbb")
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