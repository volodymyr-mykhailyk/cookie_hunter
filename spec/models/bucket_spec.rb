require 'spec_helper'

describe Bucket do
  describe 'factory' do
    let(:bucket) { create(:bucket, cookies: 10)}
    it { expect(bucket.new_record?).to be_false}
  end

  describe 'get_what_can' do
    before do
      @hunter = create(:hunter)
      @bucket = create(:bucket, cookies: 5)
      @result = @bucket.get_what_can(@hunter)
    end

    it { expect(@bucket.reload.cookies).to eq(4) }
    it { expect(@result).to eq(-1)}

    describe 'user can get more than bucket has' do
      before do
        @bucket = create(:bucket, cookies: 5)
        @hunter.stockpile.update_column(:clicks, 10)
        @result = @bucket.get_what_can(@hunter.reload)
      end

      it { expect(@bucket.reload.cookies).to eq(0) }
      it { expect(@result).to eq(-5)}
    end
  end
end
