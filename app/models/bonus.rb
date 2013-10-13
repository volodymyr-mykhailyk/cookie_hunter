class Bonus < ActiveRecord::Base

  validates :type, :regeneration, :stockpile_id, presence: true

  belongs_to :stockpile
  has_one :hunter, through: :stockpile
  delegate :recalculate_regeneration, to: :stockpile

  after_create :recalculate_regeneration

end
