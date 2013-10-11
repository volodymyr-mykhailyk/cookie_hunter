class Bucket < ActiveRecord::Base

  validates_numericality_of :cookies, greater_than_or_equal_to: 0

  def add(count = 1)
    self.cookies += count
    save
  end

  def remove
    self.cookies -= 1
    save
  end

end
