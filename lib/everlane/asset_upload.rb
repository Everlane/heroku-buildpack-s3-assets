require 'aws-sdk-s3'

Aws.config.update({
  credentials: Aws::Credentials.new(
    ENV['S3_ACCESS_KEY_ID'], ENV['S3_SECRET_KEY']
  )
})

module Everlane
  module AssetUpload
  end
end

require_relative './asset_upload/configuration'
require_relative './asset_upload/file_uploader'
require_relative './asset_upload/manifest_uploader'
