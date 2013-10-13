require 'delta_attributes/bind_visitor'
require 'delta_attributes/persistence'

module ActiveRecord
  module Persistence

    class InvalidDeltaColumn < StandardError
    end

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def delta_attributes(*args)
        @_delta_attributes ||= Set.new
        return @_delta_attributes if args.empty?
        args.each do |attribute|
          if self.columns_hash[attribute.to_s].blank?
            logger.warn("#{self.to_s} model doesn't have attribute with name #{attribute} or you have pending migrations.")
            next
          end
          if self.columns_hash[attribute.to_s] && !self.columns_hash[attribute.to_s].number?
            raise InvalidDeltaColumn.new("Delta attributes only work with number attributes, column `#{attribute}` is not a number.")
          end
          @_delta_attributes.add(attribute.to_s)
        end
      end
    end
  end

end