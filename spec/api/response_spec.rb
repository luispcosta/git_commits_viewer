require 'spec_helper'

describe API::Response do
  describe '.ok' do
    it { expect(API::Response.ok('something')).to eq({success: true, result: 'something'}.to_json) }
    it { expect(API::Response.ok({something: 'one'})).to eq({success: true, result: {something: 'one'}}.to_json) }
  end

  describe '.error' do
    it { expect(API::Response.error('something')).to eq({success: false, error_message: 'something'}.to_json) }
  end
end