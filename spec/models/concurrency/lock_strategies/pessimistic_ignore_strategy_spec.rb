require 'spec_helper'
require 'models/concurrency/lock_strategies/lock_strategies_helpers'

describe Concurrency::LockStrategies::PessimisticIgnore do
  before do
    @bucket = create(:bucket, cookies: 100)
    @current_strategy = Concurrency::LockStrategies::PessimisticIgnore
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

  it 'should change cookies in sequence' do
    expect { add_cookies(2) }.to change_model(@bucket, :cookies).by(2)
    expect { add_cookies(-2) }.to change_model(@bucket, :cookies).by(-2)
  end

  describe 'concurrency' do

    describe 'changing cookies' do
      before do
        delay_execution
      end

      it 'should be thread safe and execute only first call' do
        expect { several_threads_test(:add_cookies) }.to change_model(@bucket, :cookies).by(1)
      end

      it 'should be process safe and execute only first call' do
        expect { several_processes_test(:add_cookies) }.to change_model(@bucket, :cookies).by(1)
      end
    end

    describe 'transfer cookies' do
      before do
        delay_transfer
        @target = create(:bucket, cookies: 100)
      end

      it 'should be locked while changing to target' do
        delay_execution(0.5)
        thread = run_in_thread { add_cookies(2, @target) }
        expect { transfer_cookies }.to_not change_model(@bucket, :cookies)
        thread.join
      end

      it 'should be locked while changing to bucket' do
        delay_execution(0.5)
        thread = run_in_thread { add_cookies(2, @bucket) }
        expect { transfer_cookies }.to_not change_model(@bucket, :cookies)
        thread.join
      end

      it 'should be thread safe and add cookies from first call' do
        expect { several_threads_test(:transfer_cookies) }.to change_model(@bucket, :cookies).by(1)
      end

      it 'should be thread safe and remove cookies from first call' do
        expect { several_threads_test(:transfer_cookies) }.to change_model(@target, :cookies).by(-1)
      end

      it 'should be thread safe and not change total cookies' do
        expect { several_threads_test(:transfer_cookies) }.to_not change { total_cookies }
      end

      it 'should be process safe and add cookies from first call' do
        expect { several_processes_test(:transfer_cookies) }.to change_model(@bucket, :cookies).by(1)
      end

      it 'should be process safe and remove cookies from first call' do
        expect { several_processes_test(:transfer_cookies) }.to change_model(@target, :cookies).by(-1)
      end

      it 'should be process safe and not change total cookies' do
        expect { several_processes_test(:transfer_cookies) }.to_not change { total_cookies }
      end
    end
  end
end