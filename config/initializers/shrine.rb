# frozen_string_literal: true

require "shrine"

def generate_s3_settings
  minio_settings = {endpoint: ENV["S3_HOST"], force_path_style: true}

  res = {
    access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    bucket: "mds",
    prefix: "images",
    region: "us-east-1",
    public: true
  }

  if ENV["S3_HOST"].present?
    res.merge!(minio_settings)
  end

  res
end

if Rails.env.test?
  require "shrine/storage/file_system"
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),
    audio: Shrine::Storage::FileSystem.new("public", prefix: "uploads/music")
  }
else
  require "shrine/storage/s3"

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(**generate_s3_settings.merge(bucket: "mds", prefix: "cache")),
    store: Shrine::Storage::S3.new(**generate_s3_settings),
    audio: Shrine::Storage::S3.new(**generate_s3_settings.merge(bucket: "mds", prefix: "music", public: false))
  }
end

Shrine.plugin :activerecord # or :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :determine_mime_type
