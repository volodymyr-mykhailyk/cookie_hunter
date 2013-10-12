require 'spec_helper'

describe Concurrency::LockStrategies::Plain do
  before do
    @bucket = create(:bucket, cookies: 100)
    @bucket.stub(:change_lock_strategy).and_return Concurrency::LockStrategies::Plain.new(@bucket)
  end

  def perform_change(amount)
    @bucket.add(amount)
  end

  it 'should change cookies with current strategy' do
    expect { perform_change(2) }.to change_model(@bucket, :cookies).by(2)
    expect { perform_change(-2) }.to change_model(@bucket, :cookies).by(-2)
  end

  it 'should return changed value' do
    expect { perform_change(2) }.to return_value(2)
    expect { perform_change(-2) }.to return_value(-2)
  end

  it 'should not be thread safe' do
    pending 'something wierd with postgress transactions'
    several_threads { perform_change(3) }
    expect(@bucket.reload.cookies).to be > 101
  end
end