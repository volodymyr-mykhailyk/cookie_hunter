class Stockpile < ActiveRecord::Base
  REGENERATION_TIME = 59
  include Cookable

  belongs_to :hunter
  has_many :bonuses, dependent: :destroy, class_name: 'Bonus'

  validates_numericality_of :regeneration, greater_than_or_equal_to: 0

  def self.regenerate_cookies
    Stockpile.connection.execute("UPDATE stockpiles SET cookies = cookies + regeneration")
  end

  def buy_bonus(bonus_klass)
    price = bonus_klass::PRICE
    if cookies >= price
      self.cookies -= price
      self.save
      self.bonuses << bonus_klass.create
    else
      false
    end
  end

  def categorized_bonuses
    hash = {}
    Bonus::TYPES.map do |type|
      count = type.where(stockpile: self).count
      hash.merge!(type.new => count) if count > 0
    end
    hash
  end

  def recalculate_regeneration
    regeneration = bonuses.sum(:regeneration)
    update_column(:regeneration, regeneration)
  end


end
