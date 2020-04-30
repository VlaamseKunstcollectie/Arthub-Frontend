require "net/https"
require "uri"

Riiif::Image.file_resolver = Riiif::HTTPFileResolver.new

Riiif::Image.file_resolver.id_to_uri = lambda do |id|
    # Get rid of the nl: or en: part before the id
    id = id.gsub(/#{I18n.locale.to_s}:/, '')
    parts = id.split(':')
    domain = parts.first
    pid = parts.last

    if (id == "arthub:placeholder")
        # return "#{Rails.root}/public/copyrighted_image.png"
        return "#{Rails.root}/public/no_image_available.png"
    else
        uri = URI.parse("http://resolver.#{domain}.be/collection/work/representation/#{pid}")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        request.initialize_http_header({"User-Agent" => "Arthub RIIIF"})
    
        response = http.request (request)

        if (response.code != "303")
            return "#{Rails.root}/public/no_image_available.png"
        end
    end

    return "http://resolver.#{domain}.be/collection/work/representation/#{pid}"
end

Riiif.not_found_image = "#{Rails.root}/public/no_image_available.png"
# Riiif.unauthorized_image = 'path/to/unauthorized_image.png'
