module SpammingProtected
  extend ActiveSupport::Concern
  include Concurrency::RedisCooldown

  module ClassMethods
    def request_cooldown_filter(method_name, lock_name, cooldown_ms = 100, options = {})
      before_filter options do
        send(method_name) unless cooldown("#{lock_name}_#{@hunter.id}", cooldown_ms) { true }
      end
    end
  end
end