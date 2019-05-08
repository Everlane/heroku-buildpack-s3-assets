module Everlane::AssetUpload
  class Configuration
    attr_reader :app_dir, :bucket

    def initialize(app_dir:, bucket:, debug: false)
      @app_dir = app_dir
      @bucket = bucket
      @debug = debug
    end

    def debug?
      !!@debug
    end

    def upload?
      !!(app_dir && bucket)
    end
  end
end
