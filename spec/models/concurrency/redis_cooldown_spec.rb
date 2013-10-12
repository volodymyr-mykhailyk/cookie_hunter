require 'spec_helper'

describe Concurrency::RedisCooldown do
  include Concurrency::RedisCooldown

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

  def tester_function(cooldown_timeout = 1000)
    cooldown('tester_function', cooldown_timeout) {
      set_counter(get_counter + 1)
    }
  end

  it 'should increase counter' do
    expect { tester_function }.to change { get_counter }.by(1)
  end

  it 'should not execute second function while cooldown' do
    expect { tester_function }.to change { get_counter }.by(1)
    expect { tester_function }.to_not change { get_counter }
  end

  it 'should execute second function when timeout passed' do
    expect { tester_function }.to change { get_counter }.by(1)
    sleep(1)
    expect { tester_function }.to change { get_counter }.by(1)
  end

  it 'should skip one call if lock corrupted' do
    REDIS.set(lock_key('tester_function'), 'blabla')
    expect { tester_function }.to_not change { get_counter }
    expect { tester_function }.to change { get_counter }.by(1)
  end

  it 'should not work if previous call throwed execption' do
    expect { lock('tester_function') { raise 'eeee' } }.to raise_error
    expect { tester_function }.to change { get_counter }.by(1)
  end

  describe 'while in cooldown' do
    it 'should should not update counter by several threads' do
      expect { several_threads { tester_function } }.to change { get_counter }.by(1)
    end

    it 'should should not update counter by several processes' do
      expect { several_processes { tester_function } }.to change { get_counter }.by(1)
    end
  end
end
