module Everlane::AssetUpload
  class Configuration
    attr_reader :key, :app_dir, :bucket, :secret

    def initialize(key:, app_dir:, bucket:, secret:)
      @app_dir = app_dir
      @bucket = bucket
      @key = key
      @secret = secret
    end

    def upload?
      bucket && has_credentials?
    end

    private

    def has_credentials?
      !!(key && secret)
    end
  end
end
