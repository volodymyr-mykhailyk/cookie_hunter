class Stockpile < ActiveRecord::Base
  include Cookable

  belongs_to :hunter

  validates_numericality_of :regeneration, greater_than_or_equal_to: 0

end
