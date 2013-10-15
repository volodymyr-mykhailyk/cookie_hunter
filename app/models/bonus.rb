class Bonus < ActiveRecord::Base

  TYPES = [ClickBonus, GrandMotherBonus]
  validates :type, :regeneration, :stockpile_id, presence: true

  belongs_to :stockpile
  has_one :hunter, through: :stockpile
  delegate :recalculate_regeneration, to: :stockpile

  after_create :recalculate_regeneration
  before_validation :set_regeneration

  def set_regeneration
    self.regeneration = self.class::REGENERATION
  end

  def name
    self.class::NAME
  end

  def price
    self.class::PRICE
  end

  def regeneration_rate
    self.class::REGENERATION
  end

  def to_hash
    { name: name, price: price, regeneration: regeneration_rate, class: self.class.name }
  end

  class << self
    def get_available_bonuses(cookies)
      instances = TYPES.select { |type| type::PRICE <= cookies}.map(&:new)
      instances.map!{ |bonus| bonus.to_hash }
    end
  end
end
