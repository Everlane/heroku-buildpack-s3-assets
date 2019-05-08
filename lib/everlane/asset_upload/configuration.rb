module Everlane::AssetUpload
  class Configuration
    attr_reader :key, :app_dir, :bucket, :secret

    def initialize(app_dir:, bucket:, key:, secret:)
      @app_dir = app_dir
      @bucket = bucket
      @key = key
      @secret = secret
    end

    def upload?
      !!(app_dir && bucket && key && secret)
    end
  end
end
