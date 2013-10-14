require 'spec_helper'

describe Bucket do
  describe 'factory' do
    let(:bucket) { create(:bucket, cookies: 10)}
    it { expect(bucket.new_record?).to be_false}
  end
end
