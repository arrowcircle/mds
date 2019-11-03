class ImageUploader < Shrine
  plugin :remote_url, max_size: 4 * 1024 * 1024
  plugin :determine_mime_type, analyzer: :marcel
  plugin :infer_extension, inferrer: :mini_mime
  plugin :validation_helpers
  plugin :default_storage, store: :images, cache: :cache

  Attacher.validate do
    validate_extension_inclusion %w[jpg jpeg]
    validate_mime_type_inclusion %w[image/jpeg]
  end
end
