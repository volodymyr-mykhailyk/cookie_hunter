#if !defined?(Rake) || Rails.env.test?
  require 'delta_attributes/main'
#end