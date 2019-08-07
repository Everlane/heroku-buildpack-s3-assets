require_relative './spec_helper'
require 'everlane/asset_upload'

describe Everlane::AssetUpload::ManifestUploader do
  let(:manifest) do
    {
      "admin.css": "/assets/css/admin-04149f31.chunk.css",
      "admin.js": "/assets/js/admin-4350ce6e88a92e869e8d.chunk.js",
      "entrypoints": {
        "admin": {
          "js": [
            "/assets/js/sonic-851fd1bf641b3d41397b.js",
            "/assets/js/admin-4350ce6e88a92e869e8d.chunk.js"
          ],
          "css": [
            "/assets/css/admin-04149f31.chunk.css"
          ],
        },
      },
    }
  end

  let(:subject) do
    Everlane::AssetUpload::ManifestUploader.new(config: config, manifest: manifest)
  end

  describe 'with a valid config' do
    let(:config) do
      Everlane::AssetUpload::Configuration.new(
        app_dir: '/path/to/app',
        bucket: 'my-bucket',
      )
    end

    it 'creates a file-upload for each manifest item, ignoring "entrypoints"' do
      files = subject.files
      expect(files.length).to eq(3)
    end

    it 'expands the full local path' do
      files = subject.files
      expect(files[0].local_path).to eq('/path/to/app/public/assets/css/admin-04149f31.chunk.css')
      expect(files[1].local_path).to eq('/path/to/app/public/assets/js/admin-4350ce6e88a92e869e8d.chunk.js')
      expect(files[2].local_path).to eq('/path/to/app/public/assets/js/sonic-851fd1bf641b3d41397b.js')
    end

    it 'passes the webpack public path through with leading / removed' do
      files = subject.files
      expect(files[0].remote_path).to eq('assets/css/admin-04149f31.chunk.css')
      expect(files[1].remote_path).to eq('assets/js/admin-4350ce6e88a92e869e8d.chunk.js')
      expect(files[2].remote_path).to eq('assets/js/sonic-851fd1bf641b3d41397b.js')
    end
  end

  describe 'with an invalid config' do
    let(:config) do
      Everlane::AssetUpload::Configuration.new(
        app_dir: nil,
        bucket: nil,
      )
    end

    it 'does not upload if in the wrong environment' do
      expect(Everlane::AssetUpload::FileUploader).not_to receive(:new)
      subject.call
    end
  end
end
