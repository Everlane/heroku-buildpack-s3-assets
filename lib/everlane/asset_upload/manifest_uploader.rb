module Everlane::AssetUpload
  class ManifestUploader
    def initialize(config:, manifest: nil)
      @config = config
      @manifest = manifest || parse_manifest
    end

    def call
      return unless config.upload?

      files.each { |f| f.call }
    end

    def files
      manifest_files.map do |path|
        FileUploader.new(
          bucket: bucket,
          debug: config.debug?,
          local_path: local_path(path),
          remote_path: remote_path(path)
        )
      end
    end

    def manifest_files
      get_files_from_manifest(@manifest).to_a
    end

    def get_files_from_manifest(manifest)
      unique_files = Set.new
      manifest.each do |_, val|
        if val.instance_of?(String)
          unique_files.add(val)
        elsif val.instance_of?(Array)
          unique_files.merge(val)
        else
          unique_files.merge(get_files_from_manifest(val))
        end
      end
      unique_files
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

    def parse_manifest
      JSON.parse(
        File.read(
          File.join(config.app_dir, 'public', 'assets', 'manifest.json')
        )
      )
    end
  end
end
