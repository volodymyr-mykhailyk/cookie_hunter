module Bonuses
  class Bonus < ActiveRecord::Base

    self.table_name = 'bonuses'

    def self.types
      [
          Bonuses::ClickBonus.types,
          Bonuses::SaveBonus.types,
          Bonuses::RegenerationBonus.types,
          Bonuses::StealBonus.types
      ].flatten
    end
    validates :type, :stockpile_id, presence: true

    belongs_to :stockpile
    has_one :hunter, through: :stockpile


    def name
      self.class::NAME
    end

    def description
      self.class::DESCRIPTION
    end

    def price_for(stockpile)
      count = stockpile.bonus_count(self.class)
      self.class::BASIC_PRICE * ( 1 + count )
    end

    def value
      raise "override in #{self.class.name}"
    end

    def to_hash
      { name: name, class: self.class.name, value: value, description: description }
    end

    class << self
      def all_bonuses_for(stockpile)
        instances = types.map(&:new)
        instances.map! do |bonus|
          bonus.to_hash.merge(price: bonus.price_for(stockpile))
        end
      end
    end
  end
end
