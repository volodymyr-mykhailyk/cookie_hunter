require 'spec_helper'

describe Bucket do
  before do
    @bucket = create(:bucket, cookies: 5)
  end

  describe 'locking strategies' do
    before do
      @strategy = double(:lock_strategy, perform: nil)
      @bucket.stub(:change_lock_strategy).and_return @strategy
    end

    it 'should use lock strategy for add' do
      @strategy.should_receive(:perform).and_yield
      expect { @bucket.add(3) }.to change_model(@bucket, :cookies).by(3)
    end

    it 'should use lock strategy for remove' do
      @strategy.should_receive(:perform).and_yield
      expect { @bucket.remove(3) }.to change_model(@bucket, :cookies).by(-3)
    end

    it 'should not change value if not yielded' do
      expect { @bucket.remove(3) }.to_not change_model(@bucket, :cookies)
    end

    it 'should return 0 if not yielded' do
      expect { @bucket.add(3) }.to return_value(0)
    end
  end

end