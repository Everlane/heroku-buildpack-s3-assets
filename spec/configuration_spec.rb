require_relative './spec_helper'
require 'everlane/asset_upload'

describe Everlane::AssetUpload::Configuration do
  describe '#upload?' do
    it 'is false if lacking an app_dir' do
      config = Everlane::AssetUpload::Configuration.new(app_dir: nil, bucket: 'bracket')
      expect(config.upload?).to be_falsey
    end

    it 'is false if lacking a bucket' do
      config = Everlane::AssetUpload::Configuration.new(app_dir: '.', bucket: nil)
      expect(config.upload?).to be_falsey
    end

    it 'is true with an app_dir and bucket' do
      config = Everlane::AssetUpload::Configuration.new(app_dir: '.', bucket: 'bouquet')
      expect(config.upload?).to eq(true)
    end
  end
end
