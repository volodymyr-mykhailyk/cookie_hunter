class Stockpile < ActiveRecord::Base
  REGENERATION_TIME = 10
  include Cookable

  belongs_to :hunter
  has_many :bonuses, dependent: :destroy, class_name: 'Bonuses::Bonus'

  validates_numericality_of :regeneration, greater_than_or_equal_to: 0

  def self.regenerate_cookies
    Stockpile.connection.execute("UPDATE stockpiles SET cookies = cookies + regeneration")
  end

  def add_what_should
    add(receive_per_click)
  end

  def steal_by(hunter)
    transfer_to(StealBucket.instance, hunter.steals_per_click)
  end

  def get_from(bucket)
    transfer_from(bucket, receive_per_click)
  end

  def steals_per_click
    steals
  end

  def receive_per_click
    clicks
  end

  def remove_what_can(another_hunter)
    want_steal = another_hunter.stockpile.steals
    can_steal = [cookies - saves, 0].max
    steal = [want_steal, can_steal].min
    remove(steal)
  end

  def buy_bonus(bonus_klass)
    price = bonus_klass.new.price_for(self)

    if cookies >= price
      remove(price)
      bonuses << bonus_klass.create
    else
      false
    end
  end

  def all_bonuses
    @all_bonuses ||= bonuses.to_a
  end

  def bonus_count(klass)
    all_bonuses.map(&:type).count(klass.name)
  end

  def active_bonuses
    all_bonuses.map do |bonus|
      count = bonus_count(bonus.class)
      bonus.to_hash.merge(:count => count) if count > 0
    end.uniq
  end

  def delete_all_bonuses
    bonuses.each { |bonus| bonus.destroy }
    update_attributes(clicks: 1, regeneration: 0, steals: 1, saves: 0)
  end

  def recalculate_regeneration
    regeneration = bonuses.sum(:regeneration)
    update_column(:regeneration, regeneration)
  end

  def recalculate_clicks
    clicks = bonuses.sum(:clicks)
    update_column(:clicks, clicks + 1)
  end

  def recalculate_saves
    saves = bonuses.sum(:saves)
    update_column(:saves, saves)
  end

  def recalculate_steals
    steals = bonuses.sum(:steals)
    update_column(:steals, steals + 1)
  end

  protected
  def unsafe_cookies
    [cookies - saves, 0].max
  end


end
