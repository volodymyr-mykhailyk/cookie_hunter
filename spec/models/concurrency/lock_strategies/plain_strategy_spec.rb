require 'spec_helper'

describe Concurrency::LockStrategies::Plain do
  before do
    @bucket = create(:bucket, cookies: 100)
    @bucket.stub(:change_lock_strategy).and_return(Concurrency::LockStrategies::Plain.new(@bucket))
  end

  def perform_change(amount)
    bucket = Bucket.find_by_id(@bucket.id)
    bucket.stub(:change_lock_strategy).and_return(Concurrency::LockStrategies::Plain.new(bucket))
    bucket.add(amount)
  end

  it 'should perform single request in separate thread' do
    expect {
      single_thread { perform_change(2) }
    }.to change_model(@bucket, :cookies).by(2)
  end

  it 'should perform single request in separate process' do
    expect {
      single_process { perform_change(2) }
    }.to change_model(@bucket, :cookies).by(2)
  end

  it 'should change cookies with current strategy' do
    expect {
      perform_change(2)
    }.to change_model(@bucket, :cookies).by(2)
    expect {
      perform_change(-2)
    }.to change_model(@bucket, :cookies).by(-2)
  end

  it 'should not be thread safe and execute all calls storing only last statement' do
    Cookable.stub(:change_testing_hook).and_return { sleep(0.5) }
    expect {
      several_threads([1, 2, 3]) { |amount| perform_change(amount) }
    }.to change_model(@bucket, :cookies).by(6)
  end

  it 'should not be process safe and execute all calls storing only last statement' do
    Cookable.stub(:change_testing_hook).and_return { sleep(0.5) }
    expect {
      several_processes([1, 2, 3]) { |amount| perform_change(amount) }
    }.to change_model(@bucket, :cookies).by(6)
  end
end