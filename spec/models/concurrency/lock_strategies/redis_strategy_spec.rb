require 'spec_helper'

describe Concurrency::LockStrategies::Redis do
  before do
    @bucket = create(:bucket, cookies: 100)
  end

  def perform_change(amount)
    bucket = Bucket.find_by_id(@bucket.id)
    bucket.stub(:change_lock_strategy).and_return Concurrency::LockStrategies::Redis.new(bucket)
    bucket.add(amount)
  end

  it 'should perform single request in separate thread' do
    expect { single_thread { perform_change(2) } }.to change_model(@bucket, :cookies).by(2)
  end

  it 'should perform single request in separate process' do
    expect { single_process { perform_change(2) } }.to change_model(@bucket, :cookies).by(2)
  end

  it 'should change cookies with current strategy' do
    expect { perform_change(2) }.to change_model(@bucket, :cookies).by(2)
    expect { perform_change(-2) }.to change_model(@bucket, :cookies).by(-2)
  end

  it 'should be thread safe and execute only first locked call' do
    Cookable.stub(:change_testing_hook).and_return { sleep(0.5) }
    expect { several_threads([1, 2, 3]) { |amount| perform_change(amount) } }.to change_model(@bucket, :cookies).by(1)
  end

  it 'should be process safe and execute only first locked call' do
    Cookable.stub(:change_testing_hook).and_return { sleep(0.5) }
    expect { several_processes([1, 2, 3]) { |amount| perform_change(amount) } }.to change_model(@bucket, :cookies).by(1)
  end
end