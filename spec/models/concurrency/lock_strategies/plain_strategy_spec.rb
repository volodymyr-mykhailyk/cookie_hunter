require 'spec_helper'
require 'models/concurrency/lock_strategies/lock_strategies_helpers'

describe Concurrency::LockStrategies::Plain do
  before do
    @bucket = create(:bucket, cookies: 100)
    @current_strategy = Concurrency::LockStrategies::Plain
    @deltas = Bucket.instance_variable_get(:@_delta_attributes)
    Bucket.instance_variable_set(:@_delta_attributes, Set.new)
  end

  after do
    Bucket.instance_variable_set(:@_delta_attributes, @deltas)
  end

  it 'should return changed amount' do
    add_cookies(2).should == 2
  end

  it 'should perform single request in separate thread' do
    expect { single_thread { add_cookies(2) } }.to change_model(@bucket, :cookies).by(2)
  end

  it 'should perform single request in separate process' do
    expect { single_process { add_cookies(2) } }.to change_model(@bucket, :cookies).by(2)
  end

  it 'should change cookies with current strategy' do
    expect { add_cookies(2) }.to change_model(@bucket, :cookies).by(2)
    expect { add_cookies(-2) }.to change_model(@bucket, :cookies).by(-2)
  end

  describe 'concurrency' do
    describe 'changing cookies' do
      before do
        delay_execution
      end
      it 'should not be thread safe and execute all calls (saving last)' do
        expect { several_threads_test(:add_cookies) }.to change_model(@bucket, :cookies).by(3)
      end

      it 'should not be process safe and execute all calls (saving last)' do
        expect { several_processes_test(:add_cookies) }.to change_model(@bucket, :cookies).by(3)
      end
    end

    describe 'transfer cookies' do
      before do
        @target = create(:bucket, cookies: 100)
        delay_transfer
      end

      it 'should not be locked while changing to target' do
        thread = run_in_thread { add_cookies(2, @target) }
        expect { transfer_cookies }.to change_model(@bucket, :cookies)
        thread.join
      end

      it 'should not be locked while changing to bucket' do
        thread = run_in_thread { add_cookies(2, @bucket) }
        expect { transfer_cookies }.to change_model(@bucket, :cookies)
        thread.join
      end

      it 'should not be thread safe and add cookies from all calls (saving last)' do
        expect { several_threads_test(:transfer_cookies) }.to change_model(@bucket, :cookies).by(3)
      end

      it 'should not be thread safe and remove cookies from all calls (saving all because of delta)' do
        expect { several_threads_test(:transfer_cookies) }.to change_model(@target, :cookies).by_at_most(-4)
      end

      it 'should not be thread safe and change total cookies' do
        expect { several_threads_test(:transfer_cookies) }.to change { total_cookies }
      end

      it 'should not be process safe and add cookies from  all calls (saving last)' do
        expect { several_processes_test(:transfer_cookies) }.to change_model(@bucket, :cookies).by(3)
      end

      it 'should not be process safe and remove cookies from  all calls (saving all because of delta)' do
        expect { several_processes_test(:transfer_cookies) }.to change_model(@target, :cookies).by_at_most(-4)
      end

      it 'should be process safe and not change total cookies' do
        expect { several_processes_test(:transfer_cookies) }.to change { total_cookies }
      end
    end
  end
end