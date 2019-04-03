require 'image_processing/mini_magick'

class AvatarUploader < Shrine
  plugin :processing # allows hooking into promoting
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading

  process(:store) do |io, context|
    versions = { original: io } # retain original

    io.download do |original|
      pipeline = ImageProcessing::MiniMagick.source(original)

      versions[:medium]  = pipeline.resize_to_limit!(100, 100)
      versions[:small] = pipeline.resize_to_fill!(32, 32)
      versions[:xsmall]  = pipeline.resize_to_fill!(20, 20)
    end

    versions # return the hash of processed files
  end  
end
