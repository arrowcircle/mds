class AudioUploader < Shrine
  plugin :remote_url, max_size: 1000 * 1024 * 1024
  plugin :determine_mime_type, analyzer: :marcel
  plugin :infer_extension, inferrer: :mini_mime
  plugin :validation_helpers
  plugin :pretty_location
  plugin :default_storage, store: :audio, cache: :cache

  Attacher.validate do
    validate_extension_inclusion %w[mp3]
    validate_mime_type_inclusion %w[audio/mp3 audio/mpeg]
  end
end
