Riiif::Image.file_resolver = Riiif::HTTPFileResolver.new

Riiif::Image.file_resolver.id_to_uri = lambda do |id|
    parts = id.split(':')
    domain = parts.first
    id = parts.last
    "http://resolver.#{domain}.be/collection/work/representation/#{id}"
end

# Riiif.not_found_image = 'path/to/image.png'
# Riiif.unauthorized_image = 'path/to/unauthorized_image.png'