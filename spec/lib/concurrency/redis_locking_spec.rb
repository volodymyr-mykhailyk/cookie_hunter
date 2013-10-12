require 'spec_helper'
require 'concurrency/redis_locking'

describe Concurrency::RedisLocking do
  include Concurrency::RedisLocking

  before do
    REDIS.set('counter', 0)
  end

  after do
    return_lock(lock_key('tester_function'))
  end


  def get_counter
    REDIS.get('counter').to_i
  end

  def set_counter(count)
    REDIS.set('counter', count)
  end

  def tester_function(wait_timeout = 0)
    lock('tester_function') {
      set_counter(get_counter + 1)
      sleep(wait_timeout)
    }
  end

  it 'should increase counter' do
    expect { tester_function }.to change { get_counter }.by(1)
  end

  it 'should execute 2 functions in sequence' do
    expect { tester_function }.to change { get_counter }.by(1)
    expect { tester_function }.to change { get_counter }.by(1)
  end

  it 'should execute 2 increases in sequence with timeout' do
    expect { tester_function(1) }.to change { get_counter }.by(1)
    expect { tester_function }.to change { get_counter }.by(1)
  end

  it 'should skip one call if lock corrupted' do
    REDIS.set(lock_key('tester_function'), 'blabla')
    expect { tester_function }.to_not change { get_counter }
    expect { tester_function }.to change { get_counter }.by(1)
  end

  it 'should work if previous call throwed execption' do
    expect { lock('tester_function') { raise 'eeee' } }.to raise_error
    expect { tester_function }.to change { get_counter }.by(1)
  end

  describe 'while locked' do
    it 'should should not update counter by several threads' do
      expect { several_threads { tester_function(1) } }.to change { get_counter }.by(1)
    end

    it 'should should not update counter by several processes' do
      expect { several_processes { tester_function(1) } }.to change { get_counter }.by(1)
    end
  end
end