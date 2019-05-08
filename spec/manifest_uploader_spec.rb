require_relative './spec_helper'
require 'everlane/asset_upload'

describe Everlane::AssetUpload::ManifestUploader do
  let(:manifest) do
    {
      'admin-9c00faff.css' => '/assets/admin-9c00faff.css',
      'admin-9c00faff.css.map' => '/assets/admin-9c00faff.css.map',
      'entrypoints' => {
        'admin' => {
          'css' => [ '/assets/admin-9c00faff.css' ],
          'css.map' => [ '/assets/admin-9c00faff.css.map' ],
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
      expect(files.length).to eq(2)
    end

    it 'expands the full local path' do
      files = subject.files
      expect(files[0].local_path).to eq('/path/to/app/public/assets/admin-9c00faff.css')
      expect(files[1].local_path).to eq('/path/to/app/public/assets/admin-9c00faff.css.map')
    end

    it 'passes the webpack public path through with leading / removed' do
      files = subject.files
      expect(files[0].remote_path).to eq('assets/admin-9c00faff.css')
      expect(files[1].remote_path).to eq('assets/admin-9c00faff.css.map')
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
