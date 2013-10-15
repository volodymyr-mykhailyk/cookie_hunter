class AddColumnsToStockpiles < ActiveRecord::Migration
  def change
    add_column :stockpiles, :clicks, :integer, default: 1
    add_column :stockpiles, :saves, :integer, limit: 8, default: 0
    add_column :stockpiles, :steals, :integer, default: 1
  end
end
