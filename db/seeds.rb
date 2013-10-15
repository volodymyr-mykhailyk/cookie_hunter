# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Stockpile.find_each do |stockpile|
  stockpile.delete_all_bonuses
end

Hunter.find_each do |hunter|
  hunter.send(:create_new_stockpile) unless hunter.stockpile
end
