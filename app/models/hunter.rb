class Hunter < ActiveRecord::Base
  include Huntable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  delegate :active_bonuses, to: :stockpile
  has_many :bonuses, through: :stockpile


end
