module Everlane::AssetUpload
  class ManifestUploader
    def initialize(config:, manifest: nil)
      @config = config
      @manifest = manifest
    end

    def call
      return unless config.upload?

      files.each { |f| f.call }
    end

    def files
      manifest.values.map do |path|
        FileUploader.new(bucket, local_path(path), remote_path(path))
      end
    end

    def self.call(*args)
      new(*args).call
    end

    private

    attr_reader :config

    def remote_path(path)
      path.sub(/^\//, '')
    end

    def local_path(path)
      File.join(config.app_dir, 'public', path)
    end

    def bucket
      config.bucket
    end

    def manifest
      # See also config/webpack/environment.js
      @manifest ||= JSON.parse(
        File.read(
          File.join(config.app_dir, 'public', 'assets', 'manifest.json')
        )
      ).tap { |m| m.delete 'entrypoints' }
    end
  end
end
