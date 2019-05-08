require 'mime-types'

module Everlane::AssetUpload
  class FileUploader
    attr_reader :bucket, :local_path, :remote_path

    CACHE_CONTROL = 'public, max-age=31536000, immutable'
    DEFAULT_MIME_TYPE = MIME::Types['application/octet-stream']

    def initialize(bucket:, debug:, local_path:, remote_path:)
      @bucket = bucket
      @debug = debug
      @local_path = local_path
      @remote_path = remote_path
    end

    def call
      resource.
        object(remote_path).
        upload_file(local_path, {
          cache_control: CACHE_CONTROL,
          content_type: mime_type
        })

      FileUtils.remove(local_path)

      puts "  ✓ #{remote_path}" if @debug
    end

    private

    def client
      Aws::S3::Client.new(region: 'us-east-1')
    end

    def mime_type
      type = MIME::Types.type_for(local_path)[0] || DEFAULT_MIME_TYPE
      type.to_s
    end

    def resource
      return @resource if @resource
      res = Aws::S3::Resource.new(client: client)
      @resource = res.bucket(bucket)
    end
  end
end
