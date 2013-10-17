module Huntable
  extend ActiveSupport::Concern

  included do
    has_one :stockpile, dependent: :destroy
    delegate :cookies, :steals_per_click, :receive_per_click, to: :stockpile
    delegate :steal_by, :add_what_should, :get_from, to: :stockpile

    after_create :create_new_stockpile
  end

  def create_new_stockpile
    create_stockpile
  end
end
