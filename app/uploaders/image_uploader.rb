class ImageUploader < Shrine
  plugin :remote_url, max_size: 10 * 1024 * 1024
  plugin :determine_mime_type, analyzer: :marcel
  plugin :infer_extension, inferrer: :mini_mime
  plugin :validation_helpers
  plugin :default_storage, store: :store, cache: :cache

  Attacher.validate do
    validate_extension_inclusion %w[jpg jpeg png gif webp avif]
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
  end
end
