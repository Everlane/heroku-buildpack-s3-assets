require_relative './spec_helper'
require 'everlane/asset_upload'

describe Everlane::AssetUpload::Configuration do
  describe '#upload?' do
    it 'is false if lacking the bucket env var' do
      config = Everlane::AssetUpload::Configuration.new(app_dir: '.', bucket: nil, key: 'key.1234', secret: 'sekret.1234')
      expect(config.upload?).to be_falsey
    end

    it 'is false if lacking the key env var' do
      config = Everlane::AssetUpload::Configuration.new(app_dir: '.', bucket: 'bouquet', key: nil, secret: 'sekret.1234')
      expect(config.upload?).to be_falsey
    end

    it 'is false if lacking the secret env var' do
      config = Everlane::AssetUpload::Configuration.new(app_dir: '.', bucket: 'bouquet', key: 'key.1234', secret: nil)
      expect(config.upload?).to be_falsey
    end

    it 'will be true with a bucket and credentials on admin (or .com)' do
      config = Everlane::AssetUpload::Configuration.new(app_dir: '.', bucket: 'bouquet', key: 'key.1234', secret: 'sekret.1234')
      expect(config.upload?).to eq(true)
    end
  end
end
