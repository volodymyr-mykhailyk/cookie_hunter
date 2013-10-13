class Stockpile < ActiveRecord::Base
  include Cookable

  belongs_to :hunter
  has_many :bonuses, dependent: :destroy, class_name: 'Bonus'

  validates_numericality_of :regeneration, greater_than_or_equal_to: 0

  def recalculate_regeneration
    regeneration = bonuses.sum(:regeneration)
    update_column(:regeneration, regeneration)
  end
end
