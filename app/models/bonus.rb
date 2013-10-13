class Bonus < ActiveRecord::Base

  TYPES = [ClickBonus]
  validates :type, :regeneration, :stockpile_id, presence: true

  belongs_to :stockpile
  has_one :hunter, through: :stockpile
  delegate :recalculate_regeneration, to: :stockpile

  after_create :recalculate_regeneration

  def name
    self.class::NAME
  end

  def price
    self.class::PRICE
  end

  def regeneration
    super || self.class::REGENERATION
  end

  class << self
    def get_available_bonuses(cookies)
      TYPES.select { |type| type::PRICE <= cookies}.map(&:new)
    end
  end
end
