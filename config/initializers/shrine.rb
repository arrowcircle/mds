# frozen_string_literal: true

require 'shrine'

def generate_s3_settings
  minio_settings = { endpoint: ENV['S3_HOST'], force_path_style: true }

  res = {
    access_key_id: ENV['S3_ACCESS_KEY'],
    secret_access_key: ENV['S3_SECRET'],
    bucket: 'images',
    prefix: 'mds',
    region: 'us-east-1',
    public: true
  }

  if ENV['S3_HOST'].present?
    res.merge!(minio_settings)
  end

  res
end

if Rails.env.test?
  require 'shrine/storage/file_system'
  Shrine.storages = {
    images: Shrine::Storage::FileSystem.new('public', prefix: 'uploads'),
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache')
  }
else
  require 'shrine/storage/s3'

  Shrine.storages = {
    images: Shrine::Storage::S3.new(**generate_s3_settings),
    cache: Shrine::Storage::S3.new(**generate_s3_settings.merge(bucket: 'cache', prefix: nil)),
  }
end

Shrine.plugin :activerecord # or :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :determine_mime_type
