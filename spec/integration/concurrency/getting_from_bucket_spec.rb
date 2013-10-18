require 'spec_helper'

feature 'Concurrent getting from bucket' do
  before do
    @hunters = 3.times.map { create(:hunter) }
    StealBucket.instance.update_attribute(:cookies, 10)
  end

  def get_from_bucket(in_parallel_count = 1, get_times = 1)
    several_processes(in_parallel_count.times.map) do
      get_times.times do
        login_hunter(@hunters.sample)
        click_steal_bucket
      end
    end
  end

  def hunters_cookies
    @hunters.each { |hunter| hunter.reload }.sum(&:cookies)
  end

  it 'should remove cookie from bucket' do
    expect { get_from_bucket(1, 1) }.to change_model(steal_bucket, :cookies).by(-1)
  end

  it 'should add cookie to hunter' do
    expect { get_from_bucket(1, 1) }.to change { hunters_cookies }.by(1)
  end

  it 'should not change total cookies' do
    expect { get_from_bucket(5, 2) }.to_not change { total_cookies }
  end

  it 'should support locking and prevent concurrent modifications of bucket' do
    expect { get_from_bucket(5, 2) }.to change_model(steal_bucket, :cookies).by_at_least(-9).by_at_most(-1)
  end

  it 'should support locking and prevent concurrent modifications of hunters' do
    expect { get_from_bucket(5, 2) }.to change { hunters_cookies }.by_at_least(1).by_at_most(9)
  end
end
