require 'spec_helper'
require 'concurrency/redis_locking'

describe Concurrency::RedisLocking do
  include Concurrency::RedisLocking

  before do
    REDIS.set('counter', 0)
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

  describe 'while locked' do
    it 'should should not update counter by several threads' do
      expect { several_threads { tester_function(1) } }.to change { get_counter }.by(1)
    end

    it 'should should not update counter by several processes' do
      expect { several_processes { tester_function(1) } }.to change { get_counter }.by(1)
    end
  end
end