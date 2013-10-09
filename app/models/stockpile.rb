class Stockpile < ActiveRecord::Base

  belongs_to :hunter

  validates_numericality_of :cookies, :regeneration, greater_than_or_equal_to: 0


  def add
    self.cookies += 1
    save
  end

end
