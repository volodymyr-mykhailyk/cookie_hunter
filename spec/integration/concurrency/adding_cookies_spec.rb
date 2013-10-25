require 'spec_helper'

feature 'Concurrent cookies add' do
  before do
    @hunter = login_hunter
    visit hunting_path
  end

  def add_cookies(in_parallel_count = 1, get_times = 1)
    several_processes(in_parallel_count.times.map) do
      get_times.times do
        login_hunter(@hunter)
        click_own_bucket
      end
    end
  end


  it 'should work in separate process' do
    expect { add_cookies }.to change_model(@hunter, :cookies).by(1)
  end

  it 'should support locking and prevent concurrent modifications in several processes' do
    expect { add_cookies(5, 2) }.to change_model(@hunter, :cookies).by_at_least(1).by_at_most(9)
  end
end