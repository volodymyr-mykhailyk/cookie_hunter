class HuntingsController < ApplicationController
  before_filter :authenticate_hunter!


  def show
    all_hunters = Hunter.all.to_a
    all_hunters.delete(@hunter)
    @hunters = all_hunters
    @steal_bucket = StealBucket.instance
  end

end