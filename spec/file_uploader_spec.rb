require_relative './spec_helper'
require 'everlane/asset_upload'

describe Everlane::AssetUpload::FileUploader do
  let(:resource) { double('aws resource') }
  let(:uploader) { double('bucket uploader') }
  let(:local_path) { '/everlane.com/public/assets/foo.css' }
  let(:remote_path) { 'abc123/foo.css' }
  let(:file_uploader) do
    Everlane::AssetUpload::FileUploader.new(
      bucket: 'frucket',
      debug: false,
      local_path: local_path,
      remote_path: remote_path
    )
  end

  before do
    allow(Aws::S3::Resource).to receive(:new).and_return(resource)
    allow(resource).to receive(:bucket).and_return(resource)
    allow(resource).to receive(:object).and_return(uploader)
    allow(uploader).to receive(:upload_file)
  end

  it 'saves to the right bucket' do
    expect(resource).to receive(:bucket).with('frucket').and_return(resource)
    file_uploader.call
  end

  describe 'uploading assets' do

    it 'uploads to the given remote path' do
      expect(resource).to receive(:object) do |asset_name|
        expect(asset_name).to eq('abc123/foo.css')
        uploader
      end

      file_uploader.call
    end

    it 'uploads the right local file' do
      expect(uploader).to receive(:upload_file) do |path|
        expect(path).to eq(local_path)
      end

      file_uploader.call
    end

    it 'deletes the local file after uploading' do
      file_uploader.call
    end

    it 'caches assets forever' do
      expect(uploader).to receive(:upload_file) do |_, options|
        cc = options[:cache_control]
        expect(cc).to match(/max-age=31536000/)
        expect(cc).to match(/immutable/)
      end

      file_uploader.call
    end

    it 'assigns the correct MIME type' do
      expect(uploader).to receive(:upload_file) do |_, options|
        expect(options[:content_type]).to eq('text/css')
      end

      file_uploader.call
    end
  end
end
