class Hunter < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :stockpile, dependent: :destroy
  delegate :cookies, to: :stockpile
  delegate :active_bonuses, to: :stockpile
  has_many :bonuses, through: :stockpile


  after_create :create_new_stockpile

  private

  def create_new_stockpile
    create_stockpile
  end

end
