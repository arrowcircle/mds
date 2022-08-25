# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def s3_test_client
  @s3_test_client ||= Aws::S3::Client.new(
    region: "us-east-1",
    access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    endpoint: ENV["S3_HOST"],
    force_path_style: true
  )
end

def create_bucket(name)
  s3_test_client.create_bucket(bucket: name, acl: :public)
rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
  puts "Already created bucket: #{name}"
end

def create_folder(bucket, name)
  s3_test_client.put_object(bucket: bucket, acl: :public, key: "#{name}/")
end

%w[images cache].each { |n|
  create_bucket(n)
  create_folder(n, "mds")
}
