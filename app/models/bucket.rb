class Bucket < ActiveRecord::Base
  include Cookable

  def get_what_can(hunter)
    want_get = hunter.stockpile.clicks
    count = [want_get, cookies].min
    remove(count)
  end

end
