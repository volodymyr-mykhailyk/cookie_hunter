module Cookable
  extend ActiveSupport::Concern

  included do
    validates_numericality_of :cookies, greater_than_or_equal_to: 0
    delta_attributes :cookies if respond_to?(:delta_attributes)
  end

  def add(amount = 1)
    change_with_lock { change_cookies(amount) }
  end

  def remove(amount = 1)
    change_with_lock { change_cookies(-amount) }
  end

  def transfer_from(cookable, amount)
    change_with_lock do
      removed = cookable.remove(amount)
      Cookable.transfer_testing_hook
      change_cookies(-removed)
    end
  end

  protected
  def change_cookies(amount)
    self.cookies += amount
    save ? amount : nil
  end

  def change_with_lock(options = {}, &block)
    changed_amount = change_lock_strategy.perform(options) do
      Cookable.change_testing_hook
      yield
    end

    changed_amount.to_i
  end

  def change_lock_strategy
    @change_lock_strategy ||= Concurrency::LockStrategies::Plain.new(self)
  end

  def self.change_testing_hook
  end

  def self.transfer_testing_hook
  end
end