module Everlane::AssetUpload
  class Configuration
    attr_reader :app_dir, :bucket

    def initialize(app_dir:, bucket:)
      @app_dir = app_dir
      @bucket = bucket
    end

    def upload?
      !!(app_dir && bucket)
    end
  end
end
