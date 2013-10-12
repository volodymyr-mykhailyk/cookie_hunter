module Cookable
  extend ActiveSupport::Concern

  included do
    validates_numericality_of :cookies, greater_than_or_equal_to: 0
  end

  def add(amount = 1)
    change_cookies(amount)
  end

  def remove(amount = 1)
    change_cookies(-amount)
  end

  protected
  def change_cookies(amount, options = {})
    lock_success = change_lock_strategy.perform(options) do
      Cookable.change_testing_hook
      self.cookies += amount
      save
    end

    lock_success ? amount : 0
  end

  def change_lock_strategy
    Concurrency::LockStrategies::Plain.new(self)
  end

  def self.change_testing_hook
  end
end