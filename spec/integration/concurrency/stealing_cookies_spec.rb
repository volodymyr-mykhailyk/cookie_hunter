require 'spec_helper'

feature 'Concurrent steal cookies' do
  before do
    @hunters = 3.times.map { create(:hunter) }
    @target = create(:hunter, cookies: 10)
  end

  def steal_cookies(in_parallel_count = 1, steal_times = 1)
    several_processes(in_parallel_count.times.map) do
      steal_times.times do
        login_hunter(@hunters.sample)
        click_to_steal(@target)
      end
    end
  end

  it 'should steal cookies from target in separate process' do
    expect { steal_cookies(1, 1) }.to change_model(@target, :cookies).by(-1)
  end

  it 'should add cookies to bucket in separate process' do
    expect { steal_cookies(1, 1) }.to change_model(steal_bucket, :cookies).by(1)
  end

  it 'should not change total cookies' do
    expect { steal_cookies(5, 2) }.to_not change { total_cookies }
  end

  it 'should support locking and prevent concurrent modifications of target' do
    expect { steal_cookies(5, 2) }.to change_model(@target, :cookies).by_at_least(-9).by_at_most(-1)
  end

  it 'should support locking and prevent concurrent modifications of bucket' do
    expect { steal_cookies(5, 2) }.to change_model(steal_bucket, :cookies).by_at_least(1).by_at_most(9)
  end

  d_describe 'debug of total cookies' do
    100.times do |index|
      it "should print dump in case of error. retry #{index}" do
        steal_cookies(10, 10)
        if total_cookies < 5
          puts 'fail'
          puts "stolen cookies: #{StealBucket.instance.cookies}"
          Stockpile.all.each do |stockpile|
            puts "stockpile #{stockpile.id}: #{stockpile.cookies}"
          end
        end
      end
    end

  end
end