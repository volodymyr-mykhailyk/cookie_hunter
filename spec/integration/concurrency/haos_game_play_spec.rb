require 'spec_helper'

feature 'Concurrent game play process' do
  before do
    @hunters = 5.times.map { create(:hunter, cookies: 10) }
    StealBucket.instance.update_attribute(:cookies, 10)
  end

  def another_hunter(hunter)
    @hunters.select { |target| target != hunter }.sample
  end

  def do_actions(in_parallel_count = 1, action_times = 1)
    several_processes(in_parallel_count.times.map) do
      action_times.times do
        hunter = @hunters.sample
        login_hunter(hunter)
        if [true, false].sample
          click_to_steal(another_hunter(hunter))
        else
          click_steal_bucket
        end
      end
    end
  end

  20.times do |index|
    it "should handle concurrent modification and not change total cookies via chaos gameplay. retry #{index}" do
      expect { do_actions(6, 4) }.to_not change { total_cookies }
    end
  end
end
