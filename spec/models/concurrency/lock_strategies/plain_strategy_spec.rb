require 'spec_helper'

describe Concurrency::LockStrategies::Plain do
  before do
    @bucket = create(:bucket, cookies: 100)
    @bucket.stub(:change_lock_strategy).and_return Concurrency::LockStrategies::Plain.new(@bucket)
  end

  def perform_change(amount)
    Bucket.find_by_id(@bucket.id).add(amount)
  end

  it 'should succed single request in separate thread' do
    expect { single_thread { perform_change(2) } }.to change_model(@bucket, :cookies).by(2)
  end

  it 'should succed single request in separate process' do
    pending 'problems with AR connection after process call'
    expect { single_process { perform_change(2) } }.to change_model(@bucket, :cookies).by(2)
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
    Cookable.stub(:change_testing_hook).and_return { sleep(1) }
    expect { several_threads([1, 2, 3]) { |amount| perform_change(amount) } }.to change_model(@bucket, :cookies).by(3)
  end
end